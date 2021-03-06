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
package it.eng.spagobi.services.audit;

import javax.jws.WebService;
import javax.jws.soap.SOAPBinding;
import javax.jws.soap.SOAPBinding.Style;

/**
 * Interface of audit Service
 * @author n.d.
 * @author Marco Libanori
 */
@WebService(
		name = "AuditServiceService",
		portName = "AuditServicePort",
		serviceName = "AuditService",
		targetNamespace = "http://audit.services.spagobi.eng.it/"
	)
@SOAPBinding(style = Style.RPC)
public interface AuditService {
	/**
	 *
	 * @param token     String
	 * @param user      String
	 * @param id        String
	 * @param start     String
	 * @param end       String
	 * @param state     String
	 * @param message   String
	 * @param errorCode String
	 * @return String
	 */
	String log(String token, String user, String id, String start, String end, String state, String message, String errorCode);
}
