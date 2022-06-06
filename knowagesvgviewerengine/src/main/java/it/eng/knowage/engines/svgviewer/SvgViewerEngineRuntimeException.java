/*
 * Knowage, Open Source Business Intelligence suite
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

package it.eng.knowage.engines.svgviewer;

import it.eng.spagobi.utilities.engines.SpagoBIEngineRuntimeException;

/**
 * The Class SvgViewerEngineRuntimeException.
 */
public class SvgViewerEngineRuntimeException extends SpagoBIEngineRuntimeException {

	/**
	 * The hints. List hints;
	 */

	SvgViewerEngineInstance engineInstance;

	/**
	 * Builds a <code>GeoEngineException</code>.
	 *
	 * @param message
	 *            Text of the exception
	 */
	public SvgViewerEngineRuntimeException(String message) {

		super(message);
	}

	/**
	 * Builds a <code>GeoEngineException</code>.
	 * 
	 * @param message
	 *            Text of the exception
	 * @param ex
	 *            previous Throwable object
	 */
	public SvgViewerEngineRuntimeException(String message, Throwable ex) {
		super(message, ex);
	}

	@Override
	public SvgViewerEngineInstance getEngineInstance() {
		return engineInstance;
	}

	public void setEngineInstance(SvgViewerEngineInstance engineInstance) {
		this.engineInstance = engineInstance;
	}

}
