/*
 * Knowage, Open Source Business Intelligence suite
 * Copyright (C) 2021 Engineering Ingegneria Informatica S.p.A.
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
package it.eng.spagobi.services.proxy;

import java.net.URL;

import javax.activation.DataHandler;
import javax.servlet.http.HttpSession;
import javax.xml.namespace.QName;
import javax.xml.ws.Service;

import org.apache.log4j.Logger;

import it.eng.spagobi.services.artifact.ArtifactService;
import it.eng.spagobi.services.artifact.bo.SpagoBIArtifact;
import it.eng.spagobi.services.security.exceptions.SecurityException;

/**
 *
 * Proxy of Artifact Service
 *
 */
public final class ArtifactServiceProxy extends AbstractServiceProxy {

	private static final String SERVICE_NAME = "Artifact Service";

	private static final QName SERVICE_QNAME = new QName("http://artifact.services.spagobi.eng.it/", "ArtifactService");

	private static Logger logger = Logger.getLogger(ArtifactServiceProxy.class);

	/**
	 * use this i engine context only.
	 *
	 * @param user
	 *            user ID
	 * @param session
	 *            http session
	 */
	public ArtifactServiceProxy(String user, HttpSession session) {
		super(user, session);
		if (user == null)
			logger.error("User ID IS NULL....");
		if (session == null)
			logger.error("HttpSession IS NULL....");
	}

	private ArtifactServiceProxy() {
		super();
	}

	private ArtifactService lookUp()
			throws SecurityException {
		try {
			ArtifactService service = null;

			if (serviceUrl != null) {
				URL serviceUrlWithWsdl = new URL(serviceUrl.toString() + "?wsdl");

				service = Service.create(serviceUrlWithWsdl, SERVICE_QNAME).getPort(ArtifactService.class);
			} else {
				service = Service.create(SERVICE_QNAME).getPort(ArtifactService.class);
			}
			return service;
		} catch (Exception e) {
			logger.error("Impossible to locate [" + SERVICE_NAME + "] at ["
					+ serviceUrl + "]");
			throw new SecurityException("Impossible to locate [" + SERVICE_NAME
					+ "] at [" + serviceUrl + "]", e);
		}
	}

	/**
	 * Loads artifact by name and type.
	 *
	 * @param name
	 *            String
	 * @param type
	 *            String
	 *
	 * @return Artifact
	 */
	public DataHandler getArtifactContentByNameAndType(String name, String type) {
		logger.debug("IN.name=" + name);
		logger.debug("IN.type=" + type);
		if (name == null || name.length() == 0) {
			logger.error("Artifact name is NULL");
			return null;
		}
		if (type == null || type.length() == 0) {
			logger.error("Artifact type is NULL");
			return null;
		}
		try {
			return lookUp().getArtifactContentByNameAndType(readTicket(),
					userId, name, type);
		} catch (Exception e) {
			logger.error("Error during service execution", e);

		} finally {
			logger.debug("OUT");
		}
		return null;
	}

	/**
	 * Loads artifact by id.
	 *
	 * @param name
	 *            String
	 * @param type
	 *            String
	 *
	 * @return Artifact
	 */
	public DataHandler getArtifactContentById(Integer id) {
		logger.debug("IN.id=" + id);
		if (id == null) {
			logger.error("Artifact id is NULL");
			return null;
		}
		try {
			return lookUp().getArtifactContentById(readTicket(), userId, id);
		} catch (Exception e) {
			logger.error("Error during service execution", e);

		} finally {
			logger.debug("OUT");
		}
		return null;
	}

	/**
	 * Loads artifacts by type.
	 *
	 * @param type
	 *            String
	 *
	 * @return Artifact
	 */


	/**
	 * Loads artifacts by type.
	 *
	 * @param type String
	 * @return the array of artifact of the given type
	 */
	public SpagoBIArtifact[] getArtifactsByType( String type) {
		logger.debug("IN.type=" + type);
		if (type == null) {
			logger.error("Artifact type in input is NULL");
			return null;
		}
		try {
			return lookUp().getArtifactsByType(readTicket(), userId, type);
		} catch (Exception e) {
			logger.error("Error during service execution", e);
		} finally {
			logger.debug("OUT");
		}
		return null;
	}

}
