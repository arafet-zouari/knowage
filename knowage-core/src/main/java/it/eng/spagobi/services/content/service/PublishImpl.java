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
package it.eng.spagobi.services.content.service;

import java.util.ArrayList;
import java.util.Base64;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.jamonapi.Monitor;
import com.jamonapi.MonitorFactory;

import it.eng.spago.error.EMFUserError;
import it.eng.spagobi.analiticalmodel.document.bo.BIObject;
import it.eng.spagobi.analiticalmodel.document.bo.ObjTemplate;
import it.eng.spagobi.analiticalmodel.functionalitytree.bo.LowFunctionality;
import it.eng.spagobi.commons.bo.Domain;
import it.eng.spagobi.commons.dao.DAOFactory;
import it.eng.spagobi.engines.config.bo.Engine;
import it.eng.spagobi.services.common.AbstractServiceImpl;
import it.eng.spagobi.services.security.exceptions.SecurityException;

public class PublishImpl extends AbstractServiceImpl {

    static private Logger logger = Logger.getLogger(PublishImpl.class);

    /**
     * Publish template.
     *
     * @param token the token
     * @param user the user
     * @param attributes the attributes
     *
     * @return the string
     */
    public String publishTemplate(String token, String user, HashMap attributes) {
	// TODO IMPLEMENTARE I CONTROLLI
	PublishImpl helper = new PublishImpl();
	logger.debug("IN");
	Monitor monitor =MonitorFactory.start("spagobi.service.content.publishTemplate");
	try {
	    validateTicket(token, user);
	    this.setTenantByUserId(user);
	    return helper.publishTemplate(user, attributes);
	} catch (SecurityException e) {
	    logger.error("SecurityException", e);
	    return null;
	} finally {
		this.unsetTenant();
	    monitor.stop();
	    logger.debug("OUT");
	}

    }

    private String publishTemplate(String user, HashMap attributes) {
	logger.debug("IN");
	Base64.Decoder decoder = Base64.getDecoder();
	String encodedTemplate = (String) attributes.get("TEMPLATE");
	byte[] buffer = null;
	try {

	    buffer = decoder.decode(encodedTemplate);
	    String template = new String(buffer);
	    attributes.put("TEMPLATE", template);
	    String label = (String) attributes.get("LABEL");
	    BIObject obj = DAOFactory.getBIObjectDAO().loadBIObjectByLabel(label);
	    if (obj == null) {
		obj = createBIObject();
		initBIObject(attributes, obj);
	    } else {
		obj = updateBIObject(attributes, obj);
	    }
	    return "OK";
	} catch (EMFUserError e) {
	    logger.error("IOException when decode template", e);
	    return "KO";
	} finally {
	    logger.debug("OUT");
	}
    }

    private BIObject updateBIObject(Map mapPar, BIObject obj) {
	logger.debug("IN");
	String name = (String) mapPar.get("NAME");
	String description = (String) mapPar.get("DESCRIPTION");
	String encryptStr = (String) mapPar.get("ENCRYPTED");
	Integer encrypt = (encryptStr.equalsIgnoreCase("" + false) ? new Integer(0) : new Integer(1));
	String visibleStr = (String) mapPar.get("VISIBLE");
	Integer visible = (visibleStr.equalsIgnoreCase("" + false) ? new Integer(0) : new Integer(1));
	String type = (String) mapPar.get("TYPE");

	int t = -1;
	try {
	    List biobjTypes = DAOFactory.getDomainDAO().loadListDomainsByType("BIOBJ_TYPE");
	    for (int i = 0; i < biobjTypes.size(); i++) {
		Domain domain = (Domain) biobjTypes.get(i);
		if (domain.getValueCd().equals(type))
		    t = domain.getValueId().intValue();
	    }
	} catch (EMFUserError e2) {
	    logger.error("Error while retive object type", e2);
	}

	Integer typeIdInt = new Integer(t);

	Engine engine = null;
	List engines = null;
	try {
	    engines = DAOFactory.getEngineDAO().loadAllEngines();
	} catch (EMFUserError e) {
	    logger.error("Error while retrive engine", e);
	}
	for (int i = 0; i < engines.size(); i++) {
	    engine = (Engine) engines.get(i);
	    if (engine.getBiobjTypeId().intValue() == typeIdInt.intValue())
		break;
	}

	obj.setName(name);
	obj.setDescription(description);

	obj.setEncrypt(encrypt);
	obj.setVisible(visible);

	obj.setEngine(engine);

	String template = (String) mapPar.get("TEMPLATE");
	//ObjTemplate objTemp = obj.getActiveTemplate();
	ObjTemplate objTemp = new ObjTemplate();
	objTemp.setName("etlTemplate.xml");
	objTemp.setContent(template.getBytes());

	Domain domain = null;
	try {
	    DAOFactory.getBIObjectDAO().modifyBIObject(obj, objTemp);
	    domain = DAOFactory.getDomainDAO().loadDomainById(engine.getBiobjTypeId());
	} catch (EMFUserError e1) {
	    logger.error("Error while retrive doomain", e1);
	}
	obj.setBiObjectTypeCode(domain.getValueCd());

	obj.setBiObjectTypeID(typeIdInt);

	logger.debug("OUT");
	return obj;
    }

    private void initBIObject(Map mapPar, BIObject obj) throws EMFUserError {

	logger.debug("IN");
	String label = (String) mapPar.get("LABEL");
	String name = (String) mapPar.get("NAME");
	String description = (String) mapPar.get("DESCRIPTION");
	String encryptStr = (String) mapPar.get("ENCRYPTED");
	Integer encrypt = (encryptStr.equalsIgnoreCase("" + false) ? new Integer(0) : new Integer(1));
	String visibleStr = (String) mapPar.get("VISIBLE");
	Integer visible = (visibleStr.equalsIgnoreCase("" + false) ? new Integer(0) : new Integer(1));
	String functionalitiyCode = (String) mapPar.get("FUNCTIONALITYCODE");
	String state = (String) mapPar.get("STATE");
	String type = (String) mapPar.get("TYPE");
	String user = (String) mapPar.get("USER");

	int t = -1;
	try {
	    List biobjTypes = DAOFactory.getDomainDAO().loadListDomainsByType("BIOBJ_TYPE");
	    for (int i = 0; i < biobjTypes.size(); i++) {
		Domain domain = (Domain) biobjTypes.get(i);
		if (domain.getValueCd().equals(type))
		    t = domain.getValueId().intValue();
	    }
	} catch (EMFUserError e2) {
	    logger.error("Error while retrive object type from domain", e2);
	}

	Integer typeIdInt = new Integer(t);

	Engine engine = null;
	List engines = null;
	try {
	    engines = DAOFactory.getEngineDAO().loadAllEngines();
	} catch (EMFUserError e) {
	    logger.error("Error while retrive engines", e);
	}
	for (int i = 0; i < engines.size(); i++) {
	    engine = (Engine) engines.get(i);
	    if (engine.getBiobjTypeId().intValue() == typeIdInt.intValue())
		break;
	}
	logger.info(engine.getName());

	obj.setLabel(label);
	obj.setName(name);
	obj.setDescription(description);

	obj.setEncrypt(encrypt);
	obj.setVisible(visible);

	obj.setEngine(engine);
	obj.setCreationUser(user);

	String template = (String) mapPar.get("TEMPLATE");
	//ObjTemplate objTemp = obj.getActiveTemplate();
	ObjTemplate objTemp = new ObjTemplate();
	objTemp.setName("etlTemplate.xml");
	objTemp.setContent(template.getBytes());

	obj.setBiObjectTypeID(typeIdInt);
	obj.setBiObjectTypeCode(type);

	obj.setStateCode(state);
	Integer valueId = null;
	List l = DAOFactory.getDomainDAO().loadListDomainsByType("STATE");
	if (!l.isEmpty()){
		Iterator it = l.iterator();
		while(it.hasNext()){
			Domain dtemp = (Domain)it.next();
			if (dtemp.getValueCd().equals(state)){
				valueId = dtemp.getValueId();
				break;
			}
		}
	}
	obj.setStateID(valueId);

	Domain domain = null;
	try {
	    domain = DAOFactory.getDomainDAO().loadDomainById(engine.getBiobjTypeId());
	} catch (EMFUserError e1) {
	    logger.error("Error while reading domain by type");
	}
	obj.setBiObjectTypeCode(domain.getValueCd());

	List functionalities = new ArrayList();
	try {
	    functionalities = DAOFactory.getLowFunctionalityDAO().loadAllLowFunctionalities(false);
	} catch (EMFUserError e) {
	    logger.error("Error while reading functionalities", e);
	}

	List funcs = new ArrayList();
	for (int i = 0; i < functionalities.size(); i++) {
	    LowFunctionality functionality = (LowFunctionality) functionalities.get(i);
	    if (functionality.getCode().equals(functionalitiyCode)) {

		Integer id = functionality.getId();
		funcs.add(id);
		break;
	    }
	}

	obj.setFunctionalities(funcs);
	DAOFactory.getBIObjectDAO().insertBIObject(obj, objTemp);

	logger.debug("OUT");
    }

    private BIObject createBIObject() {
	logger.debug("IN");
	BIObject obj = new BIObject();

	List functionalitites = new ArrayList();

	obj.setId(new Integer(0));
	obj.setEngine(null);
	obj.setDescription("");
	obj.setLabel("");
	obj.setName("");
	obj.setEncrypt(new Integer(0));
	obj.setVisible(new Integer(1));
	obj.setRelName("");
	obj.setStateID(null);
	obj.setStateCode("");
	obj.setBiObjectTypeID(null);
	obj.setBiObjectTypeCode("");
	obj.setFunctionalities(functionalitites);
	logger.debug("OUT");
	return obj;
    }

}
