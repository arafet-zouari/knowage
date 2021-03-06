package it.eng.spagobi.functions.metadata;

// Generated 10-mag-2016 14.47.57 by Hibernate Tools 3.4.0.CR1

import it.eng.spagobi.commons.metadata.SbiHibernateModel;

/**
 * SbiFunctionInputVariable generated by hbm2java
 */
public class SbiFunctionInputVariable extends SbiHibernateModel {

	private SbiFunctionInputVariableId id;
	private SbiCatalogFunction sbiCatalogFunction;
	private String varType;
	private String varValue;

	public SbiFunctionInputVariable() {
	}

	public SbiFunctionInputVariable(SbiFunctionInputVariableId id, SbiCatalogFunction sbiCatalogFunction, String varType, String varValue) {
		this.id = id;
		this.sbiCatalogFunction = sbiCatalogFunction;
		this.varType = varType;
		this.varValue = varValue;
	}

	public SbiFunctionInputVariableId getId() {
		return this.id;
	}

	public void setId(SbiFunctionInputVariableId id) {
		this.id = id;
	}

	public SbiCatalogFunction getSbiCatalogFunction() {
		return this.sbiCatalogFunction;
	}

	public void setSbiCatalogFunction(SbiCatalogFunction sbiCatalogFunction) {
		this.sbiCatalogFunction = sbiCatalogFunction;
	}

	public String getVarType() {
		return this.varType;
	}

	public void setVarType(String varType) {
		this.varType = varType;
	}

	public String getVarValue() {
		return this.varValue;
	}

	public void setVarValue(String varValue) {
		this.varValue = varValue;
	}
}
