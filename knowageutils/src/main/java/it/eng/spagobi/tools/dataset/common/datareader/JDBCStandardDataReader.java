/*
+ * Knowage, Open Source Business Intelligence suite
 * Copyright (C) 2016 Engineering Ingegneria Informatica S.p.A.
 *
 * Knowage is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Knowage is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
package it.eng.spagobi.tools.dataset.common.datareader;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.apache.log4j.Logger;

import it.eng.spago.error.EMFInternalError;
import it.eng.spago.error.EMFUserError;
import it.eng.spagobi.tools.dataset.common.datastore.DataStore;
import it.eng.spagobi.tools.dataset.common.datastore.Field;
import it.eng.spagobi.tools.dataset.common.datastore.IDataStore;
import it.eng.spagobi.tools.dataset.common.datastore.IField;
import it.eng.spagobi.tools.dataset.common.datastore.IRecord;
import it.eng.spagobi.tools.dataset.common.datastore.Record;
import it.eng.spagobi.tools.dataset.common.metadata.FieldMetadata;
import it.eng.spagobi.tools.dataset.common.metadata.MetaData;
import it.eng.spagobi.utilities.assertion.Assert;

/**
 * @author Andrea Gioia (andrea.gioia@eng.it)
 */
public class JDBCStandardDataReader extends AbstractDataReader {

	private static transient Logger logger = Logger.getLogger(JDBCStandardDataReader.class);

	public JDBCStandardDataReader() {
	}

	@Override
	public boolean isOffsetSupported() {
		return true;
	}

	@Override
	public boolean isFetchSizeSupported() {
		return true;
	}

	@Override
	public boolean isMaxResultsSupported() {
		return true;
	}

	@Override
	public IDataStore read(Object data) throws EMFUserError, EMFInternalError {
		DataStore dataStore;
		MetaData dataStoreMeta;
		FieldMetadata fieldMeta;
		String fieldName;
		String fieldType;
		ResultSet rs;
		int columnCount;
		int columnIndex;
		int fieldPrecision;
		int fieldScale;
		logger.debug("IN");

		dataStore = null;

		try {

			Assert.assertNotNull(data, "Input parameter [data] cannot be null");
			Assert.assertTrue(data instanceof ResultSet, "Input parameter [data] cannot be of type [" + data.getClass().getName() + "]");

			rs = (ResultSet) data;

			dataStore = new DataStore();
			dataStoreMeta = new MetaData();

			logger.debug("Reading metadata ...");
			columnCount = rs.getMetaData().getColumnCount();
			for (columnIndex = 1; columnIndex <= columnCount; columnIndex++) {
				fieldMeta = new FieldMetadata();
				fieldName = rs.getMetaData().getColumnLabel(columnIndex);
				fieldType = rs.getMetaData().getColumnClassName(columnIndex);
				fieldPrecision = rs.getMetaData().getPrecision(columnIndex);
				fieldMeta.setPrecision(fieldPrecision);
				fieldScale = rs.getMetaData().getScale(columnIndex);
				fieldMeta.setScale(fieldScale);
				logger.debug("Field [" + columnIndex + "] name is equal to [" + fieldName + "]. TYPE= " + fieldType);
				fieldMeta.setName(fieldName);
				if (fieldType != null) {
					// Patch for hsql.. TODO
					if ("double".equals(fieldType.trim())) {
						fieldMeta.setType(Class.forName("java.lang.Double"));
					} else if ("int".equals(fieldType.trim())) {
						fieldMeta.setType(Class.forName("java.lang.Integer"));
					} else if ("String".equals(fieldType.trim())) {
						fieldMeta.setType(Class.forName("java.lang.String"));
					} else {
						fieldMeta.setType(Class.forName(fieldType.trim()));
					}
				}
				dataStoreMeta.addFiedMeta(fieldMeta);
			}
			dataStore.setMetaData(dataStoreMeta);
			logger.debug("Metadata readed succcesfully");

			logger.debug("Reading data ...");
			if (getOffset() > 0) {
				logger.debug("Offset is equal to [" + getOffset() + "]");

				// The following invokation causes an error on Oracle:
				// java.sql.SQLException: Nessuna riga corrente: relative rs.relative(getOffset());

				if (rs.getType() == ResultSet.TYPE_FORWARD_ONLY) {
					// TYPE_FORWARD_ONLY only supports next()
					for (int i = 0; i < getOffset(); i++) {
						rs.next();
					}
				} else {
					rs.first();
					rs.relative(getOffset() - 1);
				}

			} else {
				logger.debug("Offset not set");
			}

			long maxRecToParse = Long.MAX_VALUE;
			if (getFetchSize() > 0) {
				maxRecToParse = getFetchSize();
				logger.debug("FetchSize is equal to [" + maxRecToParse + "]");
			} else {
				logger.debug("FetchSize not set");
			}

			int recCount = 0;
			int resultNumber = 0;
			while ((recCount < maxRecToParse) && rs.next()) {
				IRecord record = new Record(dataStore);
				for (columnIndex = 1; columnIndex <= columnCount; columnIndex++) {
					Object columnValue = rs.getObject(columnIndex);
					IField field = new Field(columnValue);
					if (columnValue != null) {
						dataStoreMeta.getFieldMeta(columnIndex - 1).setType(columnValue.getClass());
					}
					record.appendField(field);
				}
				dataStore.appendRecord(record);
				recCount++;
			}
			logger.debug("Readed [" + recCount + "] records");
			logger.debug("Data readed successfully");

			if (this.isCalculateResultNumberEnabled()) {
				logger.debug("Calculation of result set number is enabled");
				resultNumber = getResultNumber(rs, maxRecToParse, recCount);
				dataStore.getMetaData().setProperty("resultNumber", new Integer(resultNumber));
			} else {
				logger.debug("Calculation of result set number is NOT enabled");
			}

		} catch (Throwable t) {
			logger.error("An unexpected error occured while reading resultset", t);
		} finally {
			logger.debug("OUT");
		}

		return dataStore;
	}

	private int getResultNumber(ResultSet rs, long maxRecToParse, int recCount) throws SQLException {
		logger.debug("IN");

		int toReturn;

		logger.debug("resultset type [" + rs.getType() + "] (" + (rs.getType() == ResultSet.TYPE_FORWARD_ONLY) + ")");
		if (rs.getType() == ResultSet.TYPE_FORWARD_ONLY) {

			int recordsCount = 0;
			if (recCount < maxRecToParse) {
				// records read where less then max records to read, therefore the resultset has been completely read
				recordsCount = getOffset() + recCount;
			} else {
				recordsCount = rs.getRow();
				while (rs.next()) {
					recordsCount++;
					// do nothing, just scroll result set
				}
			}
			toReturn = recordsCount;
		} else {
			rs.last();
			toReturn = rs.getRow();
		}

		logger.debug("Reading total record numeber is equal to [" + toReturn + "]");
		logger.debug("OUT " + toReturn);
		return toReturn;
	}
}
