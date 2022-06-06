-- META DATA
ALTER TABLE SBI_GL_TABLE RENAME TO SBI_META_TABLE;
ALTER TABLE SBI_META_TABLE RENAME LABEL TO NAME;
ALTER TABLE SBI_META_TABLE ADD SOURCE_ID INTEGER NOT NULL;
ALTER TABLE SBI_META_TABLE ADD DELETED BOOLEAN NOT NULL DEFAULT FALSE;

ALTER TABLE SBI_GL_BNESS_CLS RENAME TO SBI_META_BC;
ALTER TABLE SBI_META_BC RENAME UNIQUE_IDENTIFIER TO NAME;
-- next stmt add a relation to SBI_META_MODELS (delete the explicit name model field)
ALTER TABLE SBI_META_BC ADD MODEL_ID INTEGER NOT NULL;
ALTER TABLE SBI_META_BC ADD DELETED BOOLEAN NOT NULL DEFAULT FALSE;

-- set original values for the model referenced
UPDATE SBI_META_BC 
SET MODEL_ID = SRC.ID 
FROM (SELECT ID, NAME FROM SBI_META_MODELS) SRC 
WHERE SRC.NAME = DATAMART_NAME;
ALTER TABLE SBI_META_BC DROP COLUMN DATAMART_NAME;

CREATE TABLE SBI_META_SOURCE (
	SOURCE_ID 				INTEGER NOT NULL,
	NAME 					VARCHAR(100) NOT NULL,
	TYPE 					VARCHAR(100) NOT NULL,
	URL 					VARCHAR(100) NULL,
	LOCATION 				VARCHAR(100) NULL,
	SOURCE_SCHEMA 			VARCHAR(100) NULL,
	SOURCE_CATALOGUE    	VARCHAR(100) NULL,
	ROLE                    VARCHAR(100) NULL,	
	USER_IN 				VARCHAR(100) NOT NULL,
	USER_UP 				VARCHAR(100) DEFAULT NULL,
	USER_DE 				VARCHAR(100) DEFAULT NULL,
	TIME_IN 				TIMESTAMP NOT NULL,
	TIME_UP 				TIMESTAMP DEFAULT NULL,
	TIME_DE 				TIMESTAMP DEFAULT NULL,
	SBI_VERSION_IN 			VARCHAR(10) DEFAULT NULL,
	SBI_VERSION_UP 			VARCHAR(10) DEFAULT NULL,
	SBI_VERSION_DE 			VARCHAR(10) DEFAULT NULL,
	META_VERSION 			VARCHAR(100) DEFAULT NULL,
	ORGANIZATION 			VARCHAR(20) DEFAULT NULL,
	
	PRIMARY KEY (SOURCE_ID)
) WITHOUT OIDS;

CREATE TABLE SBI_META_TABLE_COLUMN  (
	COLUMN_ID 				INTEGER NOT NULL,
	TABLE_ID 				INTEGER NOT NULL,
	NAME 					VARCHAR(100) NOT NULL,
	TYPE					VARCHAR(100) NOT NULL,
	DELETED					BOOLEAN NOT NULL DEFAULT FALSE,
	USER_IN 				VARCHAR(100) NOT NULL,
	USER_UP 				VARCHAR(100) DEFAULT NULL,
	USER_DE 				VARCHAR(100) DEFAULT NULL,
	TIME_IN 				TIMESTAMP,
	TIME_UP 				TIMESTAMP DEFAULT NULL,
	TIME_DE 				TIMESTAMP DEFAULT NULL,
	SBI_VERSION_IN 			VARCHAR(10) DEFAULT NULL,
	SBI_VERSION_UP 			VARCHAR(10) DEFAULT NULL,
	SBI_VERSION_DE 			VARCHAR(10) DEFAULT NULL,
	META_VERSION 			VARCHAR(100) DEFAULT NULL,
	ORGANIZATION 			VARCHAR(20) DEFAULT NULL,
	
	PRIMARY KEY (COLUMN_ID)
) WITHOUT OIDS;

CREATE TABLE SBI_META_BC_ATTRIBUTE  (
	ATTRIBUTE_ID 			INTEGER NOT NULL,
	BC_ID					INTEGER NULL,
	COLUMN_ID				INTEGER NULL,
	NAME					VARCHAR(100) NOT NULL,
	TYPE					VARCHAR(100) NULL,
	DELETED					BOOLEAN NOT NULL DEFAULT FALSE,
	USER_IN 				VARCHAR(100) NOT NULL,
	USER_UP 				VARCHAR(100) DEFAULT NULL,
	USER_DE 				VARCHAR(100) DEFAULT NULL,
	TIME_IN 				TIMESTAMP,
	TIME_UP 				TIMESTAMP DEFAULT NULL,
	TIME_DE 				TIMESTAMP DEFAULT NULL,
	SBI_VERSION_IN 			VARCHAR(10) DEFAULT NULL,
	SBI_VERSION_UP 			VARCHAR(10) DEFAULT NULL,
	SBI_VERSION_DE 			VARCHAR(10) DEFAULT NULL,
	META_VERSION 			VARCHAR(100) DEFAULT NULL,
	ORGANIZATION 			VARCHAR(20) DEFAULT NULL,
	
	PRIMARY KEY (ATTRIBUTE_ID)
) WITHOUT OIDS;


CREATE TABLE SBI_META_TABLE_BC  (
	TABLE_ID 				INTEGER NOT NULL,
	BC_ID 					INTEGER NOT NULL,
	USER_IN 				VARCHAR(100) NOT NULL,
	USER_UP 				VARCHAR(100) DEFAULT NULL,
	USER_DE 				VARCHAR(100) DEFAULT NULL,
	TIME_IN 				TIMESTAMP,
	TIME_UP 				TIMESTAMP DEFAULT NULL,
	TIME_DE 				TIMESTAMP DEFAULT NULL,
	SBI_VERSION_IN 			VARCHAR(10) DEFAULT NULL,
	SBI_VERSION_UP 			VARCHAR(10) DEFAULT NULL,
	SBI_VERSION_DE 			VARCHAR(10) DEFAULT NULL,
	META_VERSION 			VARCHAR(100) DEFAULT NULL,
	ORGANIZATION 			VARCHAR(20) DEFAULT NULL,
	
	PRIMARY KEY (TABLE_ID, BC_ID)
) WITHOUT OIDS;


CREATE TABLE SBI_META_DS_BC  (
	DS_ID 					INTEGER NOT NULL,
	VERSION_NUM				INTEGER NOT NULL,
	BC_ID 					INTEGER NOT NULL,
	USER_IN 				VARCHAR(100) NOT NULL,
	USER_UP 				VARCHAR(100) DEFAULT NULL,
	USER_DE 				VARCHAR(100) DEFAULT NULL,
	TIME_IN 				TIMESTAMP NOT NULL,
	TIME_UP 				TIMESTAMP DEFAULT NULL,
	TIME_DE 				TIMESTAMP DEFAULT NULL,
	SBI_VERSION_IN 			VARCHAR(10) DEFAULT NULL,
	SBI_VERSION_UP 			VARCHAR(10) DEFAULT NULL,
	SBI_VERSION_DE 			VARCHAR(10) DEFAULT NULL,
	META_VERSION 			VARCHAR(100) DEFAULT NULL,
	ORGANIZATION 			VARCHAR(20)  NOT NULL,
	
	PRIMARY KEY (DS_ID,VERSION_NUM,ORGANIZATION,BC_ID)
) WITHOUT OIDS;


CREATE TABLE SBI_META_OBJ_DS  (
	DS_ID 					INTEGER NOT NULL,
	VERSION_NUM				INTEGER NOT NULL,
	OBJ_ID 					INTEGER NOT NULL,
	USER_IN 				VARCHAR(100) NOT NULL,
	USER_UP 				VARCHAR(100) DEFAULT NULL,
	USER_DE 				VARCHAR(100) DEFAULT NULL,
	TIME_IN 				TIMESTAMP,
	TIME_UP 				TIMESTAMP DEFAULT NULL,
	TIME_DE 				TIMESTAMP DEFAULT NULL,
	SBI_VERSION_IN 			VARCHAR(10) DEFAULT NULL,
	SBI_VERSION_UP 			VARCHAR(10) DEFAULT NULL,
	SBI_VERSION_DE 			VARCHAR(10) DEFAULT NULL,
	META_VERSION 			VARCHAR(100) DEFAULT NULL,
	ORGANIZATION 			VARCHAR(20) NOT NULL,
	
	PRIMARY KEY (DS_ID,VERSION_NUM,ORGANIZATION,OBJ_ID)
) WITHOUT OIDS;


CREATE TABLE SBI_META_JOB  (
	JOB_ID 					INTEGER NOT NULL,
	NAME					VARCHAR(100) NOT NULL,
	DELETED					BOOLEAN NOT NULL DEFAULT FALSE,
	USER_IN 				VARCHAR(100) NOT NULL,
	USER_UP 				VARCHAR(100) DEFAULT NULL,
	USER_DE 				VARCHAR(100) DEFAULT NULL,
	TIME_IN 				TIMESTAMP,
	TIME_UP 				TIMESTAMP DEFAULT NULL,
	TIME_DE 				TIMESTAMP DEFAULT NULL,
	SBI_VERSION_IN 			VARCHAR(10) DEFAULT NULL,
	SBI_VERSION_UP 			VARCHAR(10) DEFAULT NULL,
	SBI_VERSION_DE 			VARCHAR(10) DEFAULT NULL,
	META_VERSION 			VARCHAR(100) DEFAULT NULL,
	ORGANIZATION 			VARCHAR(20) DEFAULT NULL,
	
	PRIMARY KEY (JOB_ID)
) WITHOUT OIDS;


CREATE TABLE SBI_META_JOB_SOURCE  (
	JOB_ID					INTEGER NOT NULL,
	SOURCE_ID				INTEGER NOT NULL,
	USER_IN 				VARCHAR(100) NOT NULL,
	USER_UP 				VARCHAR(100) DEFAULT NULL,
	USER_DE 				VARCHAR(100) DEFAULT NULL,
	TIME_IN 				TIMESTAMP,
	TIME_UP 				TIMESTAMP DEFAULT NULL,
	TIME_DE 				TIMESTAMP DEFAULT NULL,
	SBI_VERSION_IN 			VARCHAR(10) DEFAULT NULL,
	SBI_VERSION_UP 			VARCHAR(10) DEFAULT NULL,
	SBI_VERSION_DE 			VARCHAR(10) DEFAULT NULL,
	META_VERSION 			VARCHAR(100) DEFAULT NULL,
	ORGANIZATION 			VARCHAR(20) DEFAULT NULL,
	
	PRIMARY KEY (JOB_ID, SOURCE_ID)
) WITHOUT OIDS;


CREATE TABLE SBI_META_JOB_TABLE  (
	JOB_ID					INTEGER NOT NULL,
	TABLE_ID				INTEGER NOT NULL,
	ROLE					VARCHAR(100) NOT NULL,
	USER_IN 				VARCHAR(100) NOT NULL,
	USER_UP 				VARCHAR(100) DEFAULT NULL,
	USER_DE 				VARCHAR(100) DEFAULT NULL,
	TIME_IN 				TIMESTAMP,
	TIME_UP 				TIMESTAMP DEFAULT NULL,
	TIME_DE 				TIMESTAMP DEFAULT NULL,
	SBI_VERSION_IN 			VARCHAR(10) DEFAULT NULL,
	SBI_VERSION_UP 			VARCHAR(10) DEFAULT NULL,
	SBI_VERSION_DE 			VARCHAR(10) DEFAULT NULL,
	META_VERSION 			VARCHAR(100) DEFAULT NULL,
	ORGANIZATION 			VARCHAR(20) DEFAULT NULL,
	
	PRIMARY KEY (JOB_ID,TABLE_ID)
) WITHOUT OIDS;

CREATE TABLE SBI_META_DATASET_REL (
  DS_TABLE_REL_ID  INTEGER NOT NULL,
  DATASET_ID  INTEGER NOT NULL,
  TABLE_ID  INTEGER NOT NULL,
  USER_IN  VARCHAR(100) NOT NULL,
  USER_UP  VARCHAR(100) DEFAULT NULL,
  USER_DE  VARCHAR(100) DEFAULT NULL,
  TIME_IN  TIMESTAMP,
  TIME_UP  TIMESTAMP NULL DEFAULT NULL,
  TIME_DE  TIMESTAMP NULL DEFAULT NULL,
  SBI_VERSION_IN  VARCHAR(10) DEFAULT NULL,
  SBI_VERSION_UP  VARCHAR(10) DEFAULT NULL,
  SBI_VERSION_DE  VARCHAR(10) DEFAULT NULL,
  META_VERSION  VARCHAR(100) DEFAULT NULL,
  ORGANIZATION  VARCHAR(20) DEFAULT NULL,
 PRIMARY KEY ( DS_TABLE_REL_ID )
) WITHOUT OIDS;

CREATE TABLE SBI_META_DOCUMENT_REL (
  DOC_TABLE_REL_ID  INTEGER NOT NULL,
  DOCUMENT_ID  INTEGER NOT NULL,
  TABLE_ID INTEGER NOT NULL,
  USER_IN  VARCHAR(100) NOT NULL,
  USER_UP  VARCHAR(100) DEFAULT NULL,
  USER_DE  VARCHAR(100) DEFAULT NULL,
  TIME_IN  TIMESTAMP,
  TIME_UP  TIMESTAMP NULL DEFAULT NULL,
  TIME_DE  TIMESTAMP NULL DEFAULT NULL,
  SBI_VERSION_IN  VARCHAR(10) DEFAULT NULL,
  SBI_VERSION_UP  VARCHAR(10) DEFAULT NULL,
  SBI_VERSION_DE  VARCHAR(10) DEFAULT NULL,
  META_VERSION  VARCHAR(100) DEFAULT NULL,
  ORGANIZATION  VARCHAR(20) DEFAULT NULL,
 PRIMARY KEY ( DOC_TABLE_REL_ID )
) WITHOUT OIDS;


-- ALTER --
ALTER TABLE SBI_META_TABLE ADD CONSTRAINT FK_SBI_META_TABLE_1 FOREIGN KEY (SOURCE_ID) REFERENCES SBI_META_SOURCE (SOURCE_ID) ;
ALTER TABLE SBI_META_TABLE_COLUMN ADD CONSTRAINT FK_SBI_META_COLUMN_1 FOREIGN KEY (TABLE_ID) REFERENCES SBI_META_TABLE (TABLE_ID) ;
ALTER TABLE SBI_META_BC ADD CONSTRAINT FK_SBI_META_BC_1 FOREIGN KEY (MODEL_ID) REFERENCES SBI_META_MODELS(ID) ;
ALTER TABLE SBI_META_BC_ATTRIBUTE ADD CONSTRAINT FK_SBI_META_BC_ATTRIBUTE_1 FOREIGN KEY (BC_ID) REFERENCES SBI_META_BC(BC_ID) ;
ALTER TABLE SBI_META_BC_ATTRIBUTE ADD CONSTRAINT FK_SBI_META_BC_ATTRIBUTE_2 FOREIGN KEY (COLUMN_ID) REFERENCES SBI_META_TABLE_COLUMN(COLUMN_ID) ;
ALTER TABLE SBI_META_DS_BC ADD CONSTRAINT FK_SBI_META_DS_BC_1 FOREIGN KEY (DS_ID,VERSION_NUM,ORGANIZATION) REFERENCES SBI_DATA_SET(DS_ID,VERSION_NUM,ORGANIZATION);
ALTER TABLE SBI_META_DS_BC ADD CONSTRAINT FK_SBI_META_DS_BC_2 FOREIGN KEY (BC_ID) REFERENCES SBI_META_BC(BC_ID) ;
ALTER TABLE SBI_META_TABLE_BC ADD CONSTRAINT FK_SBI_META_TABLE_BC_1 FOREIGN KEY (TABLE_ID) REFERENCES SBI_META_TABLE(TABLE_ID) ;
ALTER TABLE SBI_META_TABLE_BC ADD CONSTRAINT FK_SBI_META_TABLE_BC_2 FOREIGN KEY (BC_ID) REFERENCES SBI_META_BC(BC_ID) ;
ALTER TABLE SBI_META_OBJ_DS ADD CONSTRAINT FK_SBI_META_OBJ_DS_1 FOREIGN KEY (DS_ID,VERSION_NUM,ORGANIZATION) REFERENCES SBI_DATA_SET(DS_ID,VERSION_NUM,ORGANIZATION);
ALTER TABLE SBI_META_OBJ_DS ADD CONSTRAINT FK_SBI_META_OBJ_DS_2 FOREIGN KEY (OBJ_ID) REFERENCES SBI_OBJECTS(BIOBJ_ID) ;
ALTER TABLE SBI_META_JOB_SOURCE ADD CONSTRAINT FK_SBI_META_JOB_SOURCE_1 FOREIGN KEY (JOB_ID) REFERENCES SBI_META_JOB(JOB_ID) ;
ALTER TABLE SBI_META_JOB_SOURCE ADD CONSTRAINT FK_SBI_META_JOB_SOURCE_2 FOREIGN KEY (SOURCE_ID) REFERENCES SBI_META_SOURCE(SOURCE_ID) ;
ALTER TABLE SBI_META_JOB_TABLE ADD CONSTRAINT FK_SBI_META_JOB_TABLE_1 FOREIGN KEY (JOB_ID) REFERENCES SBI_META_JOB(JOB_ID) ;
ALTER TABLE SBI_META_JOB_TABLE ADD CONSTRAINT FK_SBI_META_JOB_TABLE_2 FOREIGN KEY (TABLE_ID) REFERENCES SBI_META_TABLE(TABLE_ID) ;

ALTER TABLE SBI_OUTPUT_PARAMETER ADD COLUMN FORMAT_CODE VARCHAR(20) NULL DEFAULT NULL;
ALTER TABLE SBI_OUTPUT_PARAMETER ADD COLUMN FORMAT_VALUE VARCHAR(20) NULL DEFAULT NULL;
ALTER TABLE SBI_OUTPUT_PARAMETER ALTER BIOBJ_ID DROP NOT NULL;

DROP TABLE IF EXISTS SBI_KPI_COMMENTS CASCADE ;
DROP TABLE IF EXISTS SBI_ALARM_DISTRIBUTION CASCADE ;
DROP TABLE IF EXISTS SBI_ALARM_CONTACT CASCADE ;
DROP TABLE IF EXISTS SBI_ALARM_EVENT CASCADE ;
DROP TABLE IF EXISTS SBI_ALARM CASCADE ;
DROP TABLE IF EXISTS SBI_KPI_MODEL_RESOURCES CASCADE ;
DROP TABLE IF EXISTS SBI_KPI_ERROR CASCADE;
DROP TABLE IF EXISTS SBI_ORG_UNIT_GRANT_NODES CASCADE;
DROP TABLE IF EXISTS SBI_ORG_UNIT_NODES CASCADE;
DROP TABLE IF EXISTS SBI_ORG_UNIT CASCADE;
DROP TABLE IF EXISTS SBI_GOAL_KPI CASCADE ;
DROP TABLE IF EXISTS SBI_GOAL_HIERARCHY CASCADE ;
DROP TABLE IF EXISTS SBI_GOAL CASCADE ;
DROP TABLE IF EXISTS SBI_ORG_UNIT_GRANT CASCADE;
DROP TABLE IF EXISTS SBI_KPI_MODEL_INST CASCADE ;
DROP TABLE IF EXISTS SBI_KPI_INST_PERIOD CASCADE ;
DROP TABLE IF EXISTS SBI_KPI_INSTANCE_HISTORY CASCADE ;
DROP TABLE IF EXISTS SBI_KPI_PERIODICITY CASCADE ;
DROP TABLE IF EXISTS SBI_KPI_VALUE CASCADE ;
DROP TABLE IF EXISTS SBI_KPI_MODEL CASCADE ;
DROP TABLE IF EXISTS SBI_KPI_INSTANCE CASCADE ;
DROP TABLE IF EXISTS SBI_KPI_DOCUMENTS CASCADE;
DROP TABLE IF EXISTS SBI_KPI_ROLE CASCADE ;
DROP TABLE IF EXISTS SBI_KPI_REL CASCADE ;
DROP TABLE IF EXISTS SBI_KPI CASCADE ;
DROP TABLE IF EXISTS SBI_MEASURE_UNIT CASCADE ;
DROP TABLE IF EXISTS SBI_THRESHOLD_VALUE CASCADE ;
DROP TABLE IF EXISTS SBI_THRESHOLD CASCADE ;
DROP TABLE IF EXISTS SBI_RESOURCES CASCADE ;
DROP TABLE IF EXISTS SBI_ORG_UNIT_HIERARCHIES CASCADE;

CREATE TABLE SBI_KPI_ALIAS (
	ID 						INTEGER NOT NULL,
	NAME 					VARCHAR(40) NOT NULL,
	
	USER_IN 				VARCHAR(100) NOT NULL,
	USER_UP 				VARCHAR(100) NULL DEFAULT NULL,
	USER_DE 				VARCHAR(100) NULL DEFAULT NULL,
	TIME_IN 				TIMESTAMP NOT NULL,
	TIME_UP 				TIMESTAMP NULL DEFAULT NULL,
	TIME_DE 				TIMESTAMP NULL DEFAULT NULL,
	SBI_VERSION_IN 			VARCHAR(10) NULL DEFAULT NULL,
	SBI_VERSION_UP 			VARCHAR(10) NULL DEFAULT NULL,
	SBI_VERSION_DE 			VARCHAR(10) NULL DEFAULT NULL,
	META_VERSION 			VARCHAR(100) NULL DEFAULT NULL,
	ORGANIZATION 			VARCHAR(20) NULL DEFAULT NULL,
	
	PRIMARY KEY (ID)
) WITHOUT OIDS;

CREATE TABLE SBI_KPI_RULE (
	ID 						INTEGER NOT NULL,
	VERSION					INTEGER NOT NULL,
	NAME 					VARCHAR(40) NOT NULL,
	DEFINITION 				VARCHAR(4000) NOT NULL,
	DATASOURCE_ID 			INTEGER NOT NULL, 
	ACTIVE                  VARCHAR(1) DEFAULT NULL,
	
	USER_IN 				VARCHAR(100) NOT NULL,
	USER_UP 				VARCHAR(100) NULL DEFAULT NULL,
	USER_DE 				VARCHAR(100) NULL DEFAULT NULL,
	TIME_IN 				TIMESTAMP NOT NULL,
	TIME_UP 				TIMESTAMP NULL DEFAULT NULL,
	TIME_DE 				TIMESTAMP NULL DEFAULT NULL,
	SBI_VERSION_IN 			VARCHAR(10) NULL DEFAULT NULL,
	SBI_VERSION_UP 			VARCHAR(10) NULL DEFAULT NULL,
	SBI_VERSION_DE 			VARCHAR(10) NULL DEFAULT NULL,
	META_VERSION 			VARCHAR(100) NULL DEFAULT NULL,
	ORGANIZATION 			VARCHAR(20) NULL DEFAULT NULL,
	
	PRIMARY KEY (ID,VERSION)
) WITHOUT OIDS;

CREATE TABLE SBI_KPI_KPI (
	ID 						INTEGER NOT NULL,
	VERSION					INTEGER NOT NULL,
	NAME 					VARCHAR(40) NOT NULL,
	DEFINITION 				VARCHAR(1024) NOT NULL,
	CARDINALITY 			VARCHAR(4000) NOT NULL,
	PLACEHOLDER 			VARCHAR(1024) NULL,
	CATEGORY_ID 			INTEGER NULL,
	THRESHOLD_ID 			INTEGER NOT NULL,
	ACTIVE                  VARCHAR(1) DEFAULT NULL,
	
	USER_IN 				VARCHAR(100) NOT NULL,
	USER_UP 				VARCHAR(100) NULL DEFAULT NULL,
	USER_DE 				VARCHAR(100) NULL DEFAULT NULL,
	TIME_IN 				TIMESTAMP NOT NULL,
	TIME_UP 				TIMESTAMP NULL DEFAULT NULL,
	TIME_DE 				TIMESTAMP NULL DEFAULT NULL,
	SBI_VERSION_IN 			VARCHAR(10) NULL DEFAULT NULL,
	SBI_VERSION_UP 			VARCHAR(10) NULL DEFAULT NULL,
	SBI_VERSION_DE 			VARCHAR(10) NULL DEFAULT NULL,
	META_VERSION 			VARCHAR(100) NULL DEFAULT NULL,
	ORGANIZATION 			VARCHAR(20) NULL DEFAULT NULL,
	
	PRIMARY KEY (ID,VERSION)
) WITHOUT OIDS;


CREATE TABLE SBI_KPI_PLACEHOLDER (
	ID 						INTEGER NOT NULL,
	NAME 					VARCHAR(40) NOT NULL,
	
	USER_IN 				VARCHAR(100) NOT NULL,
	USER_UP 				VARCHAR(100) NULL DEFAULT NULL,
	USER_DE 				VARCHAR(100) NULL DEFAULT NULL,
	TIME_IN 				TIMESTAMP NOT NULL,
	TIME_UP 				TIMESTAMP NULL DEFAULT NULL,
	TIME_DE 				TIMESTAMP NULL DEFAULT NULL,
	SBI_VERSION_IN 			VARCHAR(10) NULL DEFAULT NULL,
	SBI_VERSION_UP 			VARCHAR(10) NULL DEFAULT NULL,
	SBI_VERSION_DE 			VARCHAR(10) NULL DEFAULT NULL,
	META_VERSION 			VARCHAR(100) NULL DEFAULT NULL,
	ORGANIZATION 			VARCHAR(20) NULL DEFAULT NULL,
	
	PRIMARY KEY (ID)
) WITHOUT OIDS;

CREATE TABLE SBI_KPI_THRESHOLD (
	ID 						INTEGER NOT NULL,
	NAME 					VARCHAR(40) DEFAULT NULL,
	DESCRIPTION 			VARCHAR(1024),
	TYPE_ID 				INTEGER DEFAULT NULL,
	
	USER_IN 				VARCHAR(100) NOT NULL,
	USER_UP 				VARCHAR(100) NULL DEFAULT NULL,
	USER_DE 				VARCHAR(100) NULL DEFAULT NULL,
	TIME_IN 				TIMESTAMP NOT NULL,
	TIME_UP 				TIMESTAMP NULL DEFAULT NULL,
	TIME_DE 				TIMESTAMP NULL DEFAULT NULL,
	SBI_VERSION_IN 			VARCHAR(10) NULL DEFAULT NULL,
	SBI_VERSION_UP 			VARCHAR(10) NULL DEFAULT NULL,
	SBI_VERSION_DE 			VARCHAR(10) NULL DEFAULT NULL,
	META_VERSION 			VARCHAR(100) NULL DEFAULT NULL,
	ORGANIZATION 			VARCHAR(20) NULL DEFAULT NULL,
	
	PRIMARY KEY (ID)
) WITHOUT OIDS;

CREATE TABLE SBI_KPI_THRESHOLD_VALUE (
	ID 						INTEGER NOT NULL,
	THRESHOLD_ID 			INTEGER NOT NULL, 
	POSITION 				INTEGER DEFAULT NULL,
	LABEL 					VARCHAR(40) DEFAULT NULL,
	MIN_VALUE 				DECIMAL(22,0) DEFAULT NULL,
	INCLUDE_MIN 			VARCHAR(1) DEFAULT NULL,
	MAX_VALUE 				DECIMAL(22,0) DEFAULT NULL,
	INCLUDE_MAX 			VARCHAR(1) DEFAULT NULL,
	COLOR 					VARCHAR(20) DEFAULT NULL,
	SEVERITY_ID 			INTEGER DEFAULT NULL,
	
	USER_IN 				VARCHAR(100) NOT NULL,
	USER_UP 				VARCHAR(100) NULL DEFAULT NULL,
	USER_DE 				VARCHAR(100) NULL DEFAULT NULL,
	TIME_IN 				TIMESTAMP NOT NULL,
	TIME_UP 				TIMESTAMP NULL DEFAULT NULL,
	TIME_DE 				TIMESTAMP NULL DEFAULT NULL,
	SBI_VERSION_IN 			VARCHAR(10) NULL DEFAULT NULL,
	SBI_VERSION_UP 			VARCHAR(10) NULL DEFAULT NULL,
	SBI_VERSION_DE 			VARCHAR(10) NULL DEFAULT NULL,
	META_VERSION 			VARCHAR(100) NULL DEFAULT NULL,
	ORGANIZATION 			VARCHAR(20) NULL DEFAULT NULL,
	
	PRIMARY KEY (ID)
) WITHOUT OIDS;

CREATE TABLE SBI_KPI_RULE_OUTPUT (
	ID 						INTEGER NOT NULL,
	RULE_ID 				INTEGER NOT NULL,
	RULE_VERSION			INTEGER NOT NULL,
	TYPE_ID 				INTEGER NOT NULL,
	ALIAS_ID 				INTEGER NOT NULL,
	CATEGORY_ID 			INTEGER NULL,
	HIERARCHY_ID 			INTEGER NULL,
	
	USER_IN 				VARCHAR(100) NOT NULL,
	USER_UP 				VARCHAR(100) NULL DEFAULT NULL,
	USER_DE 				VARCHAR(100) NULL DEFAULT NULL,
	TIME_IN 				TIMESTAMP NOT NULL,
	TIME_UP 				TIMESTAMP NULL DEFAULT NULL,
	TIME_DE 				TIMESTAMP NULL DEFAULT NULL,
	SBI_VERSION_IN 			VARCHAR(10) NULL DEFAULT NULL,
	SBI_VERSION_UP 			VARCHAR(10) NULL DEFAULT NULL,
	SBI_VERSION_DE 			VARCHAR(10) NULL DEFAULT NULL,
	META_VERSION 			VARCHAR(100) NULL DEFAULT NULL,
	ORGANIZATION 			VARCHAR(20) NULL DEFAULT NULL,
	
	PRIMARY KEY (ID)
) WITHOUT OIDS;

CREATE TABLE SBI_KPI_KPI_RULE_OUTPUT (
  KPI_ID 					INTEGER NOT NULL,
  KPI_VERSION 				INTEGER NOT NULL,
  RULE_OUTPUT_ID 			INTEGER NOT NULL,
  PRIMARY KEY (KPI_ID,KPI_VERSION,RULE_OUTPUT_ID)
) WITHOUT OIDS;

CREATE TABLE SBI_KPI_RULE_PLACEHOLDER (
	RULE_ID 				INTEGER NOT NULL,
	RULE_VERSION			INTEGER NOT NULL,
	PLACEHOLDER_ID 			INTEGER NOT NULL,
	
	PRIMARY KEY (RULE_ID,RULE_VERSION,PLACEHOLDER_ID)
) WITHOUT OIDS;

CREATE TABLE SBI_KPI_TARGET (
	TARGET_ID				INTEGER NOT NULL,
	NAME 					VARCHAR(40),
	CATEGORY_ID 			INTEGER NULL,
	START_VALIDITY_DAY		TIMESTAMP NULL DEFAULT NULL,
	END_VALIDITY_DAY		TIMESTAMP NULL DEFAULT NULL,
	
	USER_IN 				VARCHAR(100) NOT NULL,
	USER_UP 				VARCHAR(100) NULL DEFAULT NULL,
	USER_DE 				VARCHAR(100) NULL DEFAULT NULL,
	TIME_IN 				TIMESTAMP NOT NULL,
	TIME_UP 				TIMESTAMP NULL DEFAULT NULL,
	TIME_DE 				TIMESTAMP NULL DEFAULT NULL,
	SBI_VERSION_IN 			VARCHAR(10) NULL DEFAULT NULL,
	SBI_VERSION_UP 			VARCHAR(10) NULL DEFAULT NULL,
	SBI_VERSION_DE 			VARCHAR(10) NULL DEFAULT NULL,
	META_VERSION 			VARCHAR(100) NULL DEFAULT NULL,
	ORGANIZATION 			VARCHAR(20) NULL DEFAULT NULL,
	
	PRIMARY KEY (TARGET_ID)
) WITHOUT OIDS;

CREATE TABLE SBI_KPI_TARGET_VALUE (
	TARGET_ID			INTEGER NOT NULL,
	KPI_ID 				INTEGER NOT NULL,
	KPI_VERSION			INTEGER NOT NULL,
	TARGET_VALUE		DOUBLE PRECISION,
	
	USER_IN 			VARCHAR(100) NOT NULL,
	USER_UP 			VARCHAR(100) NULL DEFAULT NULL,
	USER_DE 			VARCHAR(100) NULL DEFAULT NULL,
	TIME_IN 			TIMESTAMP NOT NULL,
	TIME_UP 			TIMESTAMP NULL DEFAULT NULL,
	TIME_DE 			TIMESTAMP NULL DEFAULT NULL,
	SBI_VERSION_IN 		VARCHAR(10) NULL DEFAULT NULL,
	SBI_VERSION_UP 		VARCHAR(10) NULL DEFAULT NULL,
	SBI_VERSION_DE 		VARCHAR(10) NULL DEFAULT NULL,
	META_VERSION 		VARCHAR(100) NULL DEFAULT NULL,
	ORGANIZATION 		VARCHAR(20) NULL DEFAULT NULL,
	
	PRIMARY KEY (TARGET_ID,KPI_ID,KPI_VERSION)
) WITHOUT OIDS;

CREATE TABLE SBI_KPI_EXECUTION_KPI (
    KPI_ID                 	INTEGER NOT NULL,
    KPI_VERSION            	INTEGER NOT NULL,
    EXECUTION_ID        	INTEGER NOT NULL,
    
    PRIMARY KEY (KPI_ID, KPI_VERSION, EXECUTION_ID)
) WITHOUT OIDS;

CREATE TABLE SBI_KPI_SCORECARD_KPI (
    KPI_ID                 INTEGER NOT NULL,
    KPI_VERSION            INTEGER NOT NULL,
    SCORECARD_ID         INTEGER NOT NULL,
    
    PRIMARY KEY (KPI_ID, KPI_VERSION, SCORECARD_ID)
) WITHOUT OIDS;

CREATE TABLE SBI_KPI_EXECUTION_FILTER (
  	PLACEHOLDER_ID 		INTEGER NOT NULL,
  	EXECUTION_ID 		INTEGER NOT NULL,
  	KPI_ID 				INTEGER NOT NULL,
  	KPI_VERSION 		INTEGER NOT NULL,
  	TYPE_ID 			INTEGER DEFAULT NULL,
  	VALUE 				VARCHAR(40) DEFAULT NULL,
	
	USER_IN 			VARCHAR(100) NOT NULL,
	USER_UP 			VARCHAR(100) NULL DEFAULT NULL,
	USER_DE 			VARCHAR(100) NULL DEFAULT NULL,
	TIME_IN 			TIMESTAMP NOT NULL,
	TIME_UP 			TIMESTAMP NULL DEFAULT NULL,
	TIME_DE 			TIMESTAMP NULL DEFAULT NULL,
	SBI_VERSION_IN 		VARCHAR(10) NULL DEFAULT NULL,
	SBI_VERSION_UP 		VARCHAR(10) NULL DEFAULT NULL,
	SBI_VERSION_DE 		VARCHAR(10) NULL DEFAULT NULL,
	META_VERSION 		VARCHAR(100) NULL DEFAULT NULL,
	ORGANIZATION 		VARCHAR(20) NULL DEFAULT NULL,
	
  	PRIMARY KEY (PLACEHOLDER_ID,EXECUTION_ID,KPI_ID,KPI_VERSION)
) WITHOUT OIDS;

CREATE TABLE SBI_KPI_EXECUTION (
  	ID 					INTEGER NOT NULL,
  	NAME				VARCHAR(40) NOT NULL,
	START_DATE 			TIMESTAMP NULL DEFAULT NULL,
  	END_DATE 			TIMESTAMP NULL DEFAULT NULL,
  	DELTA 				VARCHAR(1) DEFAULT NULL,
	USER_IN 			VARCHAR(100) NOT NULL,
	USER_UP 			VARCHAR(100) NULL DEFAULT NULL,
	USER_DE 			VARCHAR(100) NULL DEFAULT NULL,
	TIME_IN 			TIMESTAMP NOT NULL ,
	TIME_UP 			TIMESTAMP NULL DEFAULT NULL,
	TIME_DE 			TIMESTAMP NULL DEFAULT NULL,
	SBI_VERSION_IN 		VARCHAR(10) NULL DEFAULT NULL,
	SBI_VERSION_UP 		VARCHAR(10) NULL DEFAULT NULL,
	SBI_VERSION_DE 		VARCHAR(10) NULL DEFAULT NULL,
	META_VERSION 		VARCHAR(100) NULL DEFAULT NULL,
	ORGANIZATION 		VARCHAR(20) NULL DEFAULT NULL,
	
  	PRIMARY KEY (ID)
) WITHOUT OIDS;

CREATE TABLE SBI_KPI_SCORECARD (
  	ID 					INTEGER NOT NULL,
  	PARENT_ID 			INTEGER DEFAULT NULL,
  	NAME 				VARCHAR(40) NOT NULL,
  	CRITERION_ID 		INTEGER DEFAULT NULL,
  	OPTIONS 			VARCHAR(1000) DEFAULT NULL,
	
	USER_IN 			VARCHAR(100) NOT NULL,
	USER_UP 			VARCHAR(100) NULL DEFAULT NULL,
	USER_DE 			VARCHAR(100) NULL DEFAULT NULL,
	TIME_IN 			TIMESTAMP NOT NULL,
	TIME_UP 			TIMESTAMP NULL DEFAULT NULL,
	TIME_DE 			TIMESTAMP NULL DEFAULT NULL,
	SBI_VERSION_IN 		VARCHAR(10) NULL DEFAULT NULL,
	SBI_VERSION_UP 		VARCHAR(10) NULL DEFAULT NULL,
	SBI_VERSION_DE 		VARCHAR(10) NULL DEFAULT NULL,
	META_VERSION 		VARCHAR(100) NULL DEFAULT NULL,
	ORGANIZATION 		VARCHAR(20) NULL DEFAULT NULL,
	
  	PRIMARY KEY (ID)
) WITHOUT OIDS;

CREATE TABLE SBI_KPI_VALUE ( 
  	ID 					INTEGER NOT NULL, 
  	KPI_ID 				INTEGER NOT NULL,
  	KPI_VERSION 		INTEGER NOT NULL,
  	LOGICAL_KEY 		VARCHAR(4096),
  	TIME_RUN 			TIMESTAMP NOT NULL,
  	COMPUTED_VALUE 		DOUBLE PRECISION NOT NULL,
  	MANUAL_VALUE 		DOUBLE PRECISION,
    MANUAL_NOTE			VARCHAR(1000) NULL,
  	THE_DAY 			VARCHAR(3) NOT NULL,
  	THE_WEEK 			VARCHAR(3) NOT NULL,
  	THE_MONTH 			VARCHAR(3) NOT NULL,
  	THE_QUARTER 		VARCHAR(3) NOT NULL,
  	THE_YEAR 			VARCHAR(4) NOT NULL,
    STATE				VARCHAR(1) NOT NULL DEFAULT '0',
    
    PRIMARY KEY (ID)
) WITHOUT OIDS;

CREATE TABLE SBI_KPI_VALUE_EXEC_LOG ( 
	ID					INTEGER NOT NULL, 
	SCHEDULER_ID		INTEGER NOT NULL,
	TIME_RUN			TIMESTAMP NOT NULL,
	OUTPUT				BYTEA NULL NULL,
	ERROR_COUNT			INTEGER NOT NULL,
	SUCCESS_COUNT		INTEGER NOT NULL,
	TOTAL_COUNT			INTEGER NOT NULL,
	
	PRIMARY KEY (ID)
) WITHOUT OIDS;
ALTER TABLE SBI_KPI_EXECUTION_FILTER 		ADD CONSTRAINT FK_01_SBI_KPI_EXECUTION_FILTER 		FOREIGN KEY (EXECUTION_ID) 			REFERENCES SBI_KPI_EXECUTION (ID);
ALTER TABLE SBI_KPI_EXECUTION_FILTER 		ADD CONSTRAINT FK_02_SBI_KPI_EXECUTION_FILTER 		FOREIGN KEY (TYPE_ID) 			    REFERENCES SBI_DOMAINS (VALUE_ID);
ALTER TABLE SBI_KPI_EXECUTION_FILTER 		ADD CONSTRAINT FK_03_SBI_KPI_EXECUTION_FILTER 		FOREIGN KEY (PLACEHOLDER_ID)   	    REFERENCES SBI_KPI_PLACEHOLDER (ID);
ALTER TABLE SBI_KPI_SCORECARD 				ADD CONSTRAINT FK_02_SBI_KPI_SCORECARD 				FOREIGN KEY (CRITERION_ID) 			REFERENCES SBI_DOMAINS (VALUE_ID);
ALTER TABLE SBI_KPI_KPI 					ADD CONSTRAINT FK_01_SBI_KPI_KPI 					FOREIGN KEY (CATEGORY_ID) 			REFERENCES SBI_DOMAINS (VALUE_ID);
ALTER TABLE SBI_KPI_RULE					ADD CONSTRAINT FK_01_SBI_KPI_RULE					FOREIGN KEY (DATASOURCE_ID)			REFERENCES SBI_DATA_SOURCE (DS_ID);
ALTER TABLE SBI_KPI_THRESHOLD 				ADD CONSTRAINT FK_01_SBI_KPI_THRESHOLD 				FOREIGN KEY (TYPE_ID) 				REFERENCES SBI_DOMAINS (VALUE_ID);
ALTER TABLE SBI_KPI_THRESHOLD_VALUE 		ADD CONSTRAINT FK_01_SBI_KPI_THRESHOLD_VALUE 		FOREIGN KEY (SEVERITY_ID) 			REFERENCES SBI_DOMAINS (VALUE_ID);
ALTER TABLE SBI_KPI_THRESHOLD_VALUE			ADD CONSTRAINT FK_02_SBI_KPI_THRESHOLD_VALUE		FOREIGN KEY (THRESHOLD_ID)			REFERENCES SBI_KPI_THRESHOLD (ID);
ALTER TABLE SBI_KPI_RULE_OUTPUT 			ADD CONSTRAINT FK_01_SBI_KPI_RULE_OUTPUT 			FOREIGN KEY (TYPE_ID) 				REFERENCES SBI_DOMAINS (VALUE_ID);
ALTER TABLE SBI_KPI_RULE_OUTPUT 			ADD CONSTRAINT FK_02_SBI_KPI_RULE_OUTPUT 			FOREIGN KEY (RULE_ID,RULE_VERSION) 	REFERENCES SBI_KPI_RULE (ID,VERSION);
ALTER TABLE SBI_KPI_RULE_OUTPUT 			ADD CONSTRAINT FK_03_SBI_KPI_RULE_OUTPUT 			FOREIGN KEY (ALIAS_ID) 				REFERENCES SBI_KPI_ALIAS (ID);
ALTER TABLE SBI_KPI_RULE_OUTPUT 			ADD CONSTRAINT FK_04_SBI_KPI_RULE_OUTPUT 			FOREIGN KEY (CATEGORY_ID) 			REFERENCES SBI_DOMAINS (VALUE_ID);
ALTER TABLE SBI_KPI_RULE_PLACEHOLDER 		ADD CONSTRAINT FK_01_SBI_KPI_RULE_PLACEHOLDER 		FOREIGN KEY (RULE_ID,RULE_VERSION) 	REFERENCES SBI_KPI_RULE (ID,VERSION);
ALTER TABLE SBI_KPI_RULE_PLACEHOLDER 		ADD CONSTRAINT FK_02_SBI_KPI_RULE_PLACEHOLDER 		FOREIGN KEY (PLACEHOLDER_ID) 		REFERENCES SBI_KPI_PLACEHOLDER (ID);
ALTER TABLE SBI_KPI_KPI_RULE_OUTPUT         ADD CONSTRAINT FK_01_SBI_KPI_KPI_RULE_OUTPUT    	FOREIGN KEY (KPI_ID,KPI_VERSION)    REFERENCES SBI_KPI_KPI (ID,VERSION);
ALTER TABLE SBI_KPI_KPI_RULE_OUTPUT         ADD CONSTRAINT FK_02_SBI_KPI_KPI_RULE_OUTPUT    	FOREIGN KEY (RULE_OUTPUT_ID)        REFERENCES SBI_KPI_RULE_OUTPUT (ID);
ALTER TABLE SBI_KPI_TARGET_VALUE 			ADD CONSTRAINT FK_01_SBI_KPI_TARGET_VALUE 			FOREIGN KEY (TARGET_ID) 			REFERENCES SBI_KPI_TARGET (TARGET_ID);
ALTER TABLE SBI_KPI_TARGET_VALUE 			ADD CONSTRAINT FK_02_SBI_KPI_TARGET_VALUE 			FOREIGN KEY (KPI_ID,KPI_VERSION) 	REFERENCES SBI_KPI_KPI (ID,VERSION);
ALTER TABLE SBI_KPI_TARGET					ADD CONSTRAINT FK_03_SBI_KPI_TARGET 				FOREIGN KEY (CATEGORY_ID) 			REFERENCES SBI_DOMAINS (VALUE_ID);


CREATE TABLE SBI_ALERT_ACTION (
	ID 					INTEGER NOT NULL,
    NAME 				VARCHAR(40) NOT NULL,
    CLASS_NAME 			VARCHAR(200) NOT NULL,
    TEMPLATE			VARCHAR(200) NOT NULL,
	USER_IN 			VARCHAR(100) NOT NULL,
	USER_UP 			VARCHAR(100),
	USER_DE 			VARCHAR(100),
	TIME_IN 			TIMESTAMP NOT NULL,
	TIME_UP 			TIMESTAMP,
	TIME_DE 			TIMESTAMP,
	SBI_VERSION_IN 		VARCHAR(10),
	SBI_VERSION_UP 		VARCHAR(10),
	SBI_VERSION_DE 		VARCHAR(10),
	META_VERSION 		VARCHAR(100),
	ORGANIZATION 		VARCHAR(20),
	PRIMARY KEY(ID)
) WITHOUT OIDS;

CREATE TABLE SBI_ALERT_LISTENER (
	ID 					INTEGER NOT NULL,
    NAME 				VARCHAR(40) NOT NULL,
    CLASS_NAME 			VARCHAR(200) NOT NULL,
    TEMPLATE			VARCHAR(200) NOT NULL,
	USER_IN 			VARCHAR(100) NOT NULL,
	USER_UP 			VARCHAR(100),
	USER_DE 			VARCHAR(100),
	TIME_IN 			TIMESTAMP NOT NULL,
	TIME_UP 			TIMESTAMP,
	TIME_DE 			TIMESTAMP,
	SBI_VERSION_IN 		VARCHAR(10),
	SBI_VERSION_UP 		VARCHAR(10),
	SBI_VERSION_DE 		VARCHAR(10),
	META_VERSION 		VARCHAR(100),
	ORGANIZATION 		VARCHAR(20),
	PRIMARY KEY(ID)
) WITHOUT OIDS;

CREATE TABLE SBI_ALERT (
	ID 					INTEGER NOT NULL,
	NAME 				VARCHAR(40) NOT NULL,
	LISTENER_ID			INTEGER NOT NULL,
	LISTENER_OPTIONS    VARCHAR(4000),
	USER_IN 			VARCHAR(100) NOT NULL,
	USER_UP 			VARCHAR(100),
	USER_DE 			VARCHAR(100),
	TIME_IN 			TIMESTAMP NOT NULL,
	TIME_UP 			TIMESTAMP,
	TIME_DE 			TIMESTAMP,
	SBI_VERSION_IN 		VARCHAR(10),
	SBI_VERSION_UP 		VARCHAR(10),
	SBI_VERSION_DE 		VARCHAR(10),
	META_VERSION 		VARCHAR(100),
	ORGANIZATION 		VARCHAR(20),
	PRIMARY KEY(ID)
) WITHOUT OIDS;

CREATE TABLE SBI_ALERT_LOG (
	ID					INTEGER NOT NULL,
    LISTENER_ID		 	INTEGER NOT NULL,
    ACTION_ID			INTEGER,
    LISTENER_PARAMS		VARCHAR(4000),
    ACTION_PARAMS		VARCHAR(4000),
    DETAIL				VARCHAR(4000),
    USER_IN 			VARCHAR(100) NOT NULL,
	USER_UP 			VARCHAR(100),
	USER_DE 			VARCHAR(100),
	TIME_IN 			TIMESTAMP NOT NULL,
	TIME_UP 			TIMESTAMP,
	TIME_DE 			TIMESTAMP,
	SBI_VERSION_IN 		VARCHAR(10),
	SBI_VERSION_UP 		VARCHAR(10),
	SBI_VERSION_DE 		VARCHAR(10),
	META_VERSION 		VARCHAR(100),
	ORGANIZATION 		VARCHAR(20),
    PRIMARY KEY(ID)
) WITHOUT OIDS;

ALTER TABLE SBI_ALERT 						ADD CONSTRAINT FK_01_SBI_ALERT 						FOREIGN KEY (LISTENER_ID) 			REFERENCES SBI_ALERT_LISTENER(ID);
ALTER TABLE SBI_ALERT_LOG 					ADD CONSTRAINT FK_01_SBI_ALERT_LOG 					FOREIGN KEY (LISTENER_ID) 			REFERENCES SBI_ALERT_LISTENER(ID);
ALTER TABLE SBI_ALERT_LOG 					ADD CONSTRAINT FK_02_SBI_ALERT_LOG 					FOREIGN KEY (ACTION_ID) 			REFERENCES SBI_ALERT_ACTION(ID);

ALTER TABLE SBI_OBJECTS ADD COLUMN LOCKED_BY_USER VARCHAR(100) NULL;

ALTER TABLE  SBI_META_BC ADD UNIQUE_NAME VARCHAR(100) NULL;

UPDATE SBI_ENGINES SET MAIN_URL = '/knowagewhatifengine/restful-services/startwhatif' where LABEL = 'knowagewhatifengine';

CREATE TABLE SBI_CATALOG_FUNCTION (
  FUNCTION_ID INTEGER NOT NULL,
  NAME VARCHAR(100) NOT NULL,
  LANGUAGE VARCHAR(100) NOT NULL,
  SCRIPT TEXT NOT NULL,
  USER_IN 				VARCHAR(100) NOT NULL,
  USER_UP 				VARCHAR(100) NULL DEFAULT NULL,
  USER_DE 				VARCHAR(100) NULL DEFAULT NULL,
  TIME_IN 				TIMESTAMP NOT NULL ,
  TIME_UP 				TIMESTAMP NULL DEFAULT NULL,
  TIME_DE 				TIMESTAMP NULL DEFAULT NULL,
  SBI_VERSION_IN 		VARCHAR(10) NULL DEFAULT NULL,
  SBI_VERSION_UP 		VARCHAR(10) NULL DEFAULT NULL,
  SBI_VERSION_DE 		VARCHAR(10) NULL DEFAULT NULL,
  ORGANIZATION 			VARCHAR(20) NULL DEFAULT NULL,
  PRIMARY KEY (FUNCTION_ID)
  ) WITHOUT OIDS;
  
  
CREATE TABLE SBI_FUNCTION_INPUT_VARIABLE (
  FUNCTION_ID INTEGER NOT NULL,
  VAR_NAME VARCHAR(100) NOT NULL,
  VAR_VALUE VARCHAR(100) NOT NULL,
  USER_IN 				VARCHAR(100) NOT NULL,
  USER_UP 				VARCHAR(100) NULL DEFAULT NULL,
  USER_DE 				VARCHAR(100) NULL DEFAULT NULL,
  TIME_IN 				TIMESTAMP NOT NULL,
  TIME_UP 				TIMESTAMP NULL DEFAULT NULL,
  TIME_DE 				TIMESTAMP NULL DEFAULT NULL,
  SBI_VERSION_IN 		VARCHAR(10) NULL DEFAULT NULL,
  SBI_VERSION_UP 		VARCHAR(10) NULL DEFAULT NULL,
  SBI_VERSION_DE 		VARCHAR(10) NULL DEFAULT NULL,
  ORGANIZATION 			VARCHAR(20) NULL DEFAULT NULL,
  PRIMARY KEY (FUNCTION_ID,VAR_NAME)
  ) WITHOUT OIDS;

CREATE TABLE SBI_FUNCTION_INPUT_DATASET (
  FUNCTION_ID INTEGER NOT NULL,
  DS_ID INTEGER NOT NULL,
  USER_IN 				VARCHAR(100) NOT NULL,
  USER_UP 				VARCHAR(100) NULL DEFAULT NULL,
  USER_DE 				VARCHAR(100) NULL DEFAULT NULL,
  TIME_IN 				TIMESTAMP NOT NULL,
  TIME_UP 				TIMESTAMP NULL DEFAULT NULL,
  TIME_DE 				TIMESTAMP NULL DEFAULT NULL,
  SBI_VERSION_IN 		VARCHAR(10) NULL DEFAULT NULL,
  SBI_VERSION_UP 		VARCHAR(10) NULL DEFAULT NULL,
  SBI_VERSION_DE 		VARCHAR(10) NULL DEFAULT NULL, 
  ORGANIZATION 			VARCHAR(20) NULL DEFAULT  NULL,
  PRIMARY KEY (FUNCTION_ID, DS_ID)
  ) WITHOUT OIDS;
  
CREATE TABLE SBI_FUNCTION_OUTPUT (
 FUNCTION_ID INTEGER NOT NULL,
 LABEL VARCHAR(100) NOT NULL,
 OUT_TYPE INTEGER NOT NULL,
 USER_IN 				VARCHAR(100) NOT NULL,
 USER_UP 				VARCHAR(100) NULL DEFAULT NULL,
 USER_DE 				VARCHAR(100) NULL DEFAULT NULL,
 TIME_IN 				TIMESTAMP NOT NULL,
 TIME_UP 				TIMESTAMP NULL DEFAULT NULL,
 TIME_DE 				TIMESTAMP NULL DEFAULT NULL,
 SBI_VERSION_IN 		VARCHAR(10) NULL DEFAULT NULL,
 SBI_VERSION_UP 		VARCHAR(10) NULL DEFAULT NULL,
 SBI_VERSION_DE 		VARCHAR(10) NULL DEFAULT NULL,
 ORGANIZATION 			VARCHAR(20) NULL DEFAULT NULL,
 PRIMARY KEY (FUNCTION_ID,LABEL)
 )  WITHOUT OIDS;
 
ALTER TABLE SBI_FUNCTION_OUTPUT 			ADD CONSTRAINT FK_SBI_FUNCTION_OUTPUT_1 			FOREIGN KEY ( OUT_TYPE ) 			REFERENCES SBI_DOMAINS ( VALUE_ID ) 		 ON DELETE  RESTRICT ON UPDATE  RESTRICT;
ALTER TABLE SBI_FUNCTION_OUTPUT 			ADD CONSTRAINT FK_SBI_FUNCTION_OUTPUT_2 			FOREIGN KEY ( FUNCTION_ID ) 		REFERENCES SBI_CATALOG_FUNCTION(FUNCTION_ID) ON DELETE  RESTRICT ON UPDATE  RESTRICT;
ALTER TABLE SBI_FUNCTION_INPUT_DATASET 		ADD CONSTRAINT FK_FUNCTION_INPUT_DATASETS_2  		FOREIGN KEY (FUNCTION_ID) 			REFERENCES SBI_CATALOG_FUNCTION(FUNCTION_ID) ON DELETE  RESTRICT ON UPDATE  RESTRICT;
ALTER TABLE SBI_FUNCTION_INPUT_VARIABLE 	ADD CONSTRAINT FK_FUNCTION_INPUT_VARIABLES_1  		FOREIGN KEY (FUNCTION_ID) 			REFERENCES SBI_CATALOG_FUNCTION(FUNCTION_ID) ON DELETE  RESTRICT ON UPDATE  RESTRICT;

ALTER TABLE SBI_GL_TABLE_WLIST DROP CONSTRAINT FK_01_SBI_GL_TABLE_WLIST;

ALTER TABLE SBI_GL_TABLE_WLIST
ADD CONSTRAINT FK_01_SBI_GL_TABLE_WLIST
  FOREIGN KEY (TABLE_ID)
  REFERENCES  SBI_META_TABLE (TABLE_ID)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;
  

ALTER TABLE SBI_GL_BNESS_CLS_WLIST  DROP CONSTRAINT FK_01_SBI_GL_BNESS_CLS_WLIST;

ALTER TABLE SBI_GL_BNESS_CLS_WLIST
ADD CONSTRAINT FK_01_SBI_GL_BNESS_CLS_WLIST
  FOREIGN KEY (BC_ID)
  REFERENCES SBI_META_BC (BC_ID)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

DROP TABLE IF EXISTS SBI_GL_TABLE;
DROP TABLE IF EXISTS  SBI_GL_BNESS_CLS;

ALTER TABLE SBI_GL_TABLE_WLIST ADD COLUMN COLUMN_NAME VARCHAR(100) NOT NULL ;

ALTER TABLE SBI_GL_TABLE_WLIST DROP CONSTRAINT sbi_gl_table_wlist_pkey, ADD PRIMARY KEY (TABLE_ID, WORD_ID, COLUMN_NAME);


ALTER TABLE  SBI_GL_BNESS_CLS_WLIST 
ALTER COLUMN_NAME  SET NOT NULL, DROP CONSTRAINT SBI_GL_BNESS_CLS_WLIST_pkey,
ADD PRIMARY KEY (BC_ID, WORD_ID, COLUMN_NAME);

ALTER TABLE SBI_ALERT ADD COLUMN SINGLE_EXECUTION VARCHAR(1),
ADD COLUMN EVENT_BEFORE_TRIGGER_ACTION INTEGER;

ALTER TABLE SBI_CROSS_NAVIGATION_PAR ADD COLUMN FIXED_VALUE VARCHAR(100) NULL DEFAULT NULL;

CREATE TABLE SBI_FUNCTIONS_ORGANIZER (
       FUNCT_ID             INTEGER NOT NULL ,
       PARENT_FUNCT_ID      INTEGER NULL,
       NAME                 VARCHAR(40) NULL,
       DESCR                VARCHAR(160) NULL,
       PATH                 VARCHAR(400) NULL,
       CODE                 VARCHAR(40) NOT NULL,
       PROG 				INTEGER NOT NULL,
       USER_IN              VARCHAR(100) NOT NULL,
       USER_UP              VARCHAR(100),
       USER_DE              VARCHAR(100),
       TIME_IN              TIMESTAMP NOT NULL,
       TIME_UP              TIMESTAMP NULL DEFAULT NULL,
       TIME_DE              TIMESTAMP NULL DEFAULT NULL,
       SBI_VERSION_IN       VARCHAR(10),
       SBI_VERSION_UP       VARCHAR(10),
       SBI_VERSION_DE       VARCHAR(10),
       META_VERSION         VARCHAR(100),
       ORGANIZATION         VARCHAR(20),    
       CONSTRAINT XAK1SBI_FUNCTIONS_ORGANIZER UNIQUE  (CODE, USER_IN),
       PRIMARY KEY (FUNCT_ID)
) WITHOUT OIDS;

CREATE TABLE SBI_OBJ_FUNC_ORGANIZER (
       BIOBJ_ID             INTEGER NOT NULL,
       FUNCT_ID             INTEGER NOT NULL,
       PROG                 INTEGER NULL,
       USER_IN              VARCHAR(100) NOT NULL,
       USER_UP              VARCHAR(100),
       USER_DE              VARCHAR(100),
       TIME_IN              TIMESTAMP NOT NULL,
       TIME_UP              TIMESTAMP NULL DEFAULT NULL,
       TIME_DE              TIMESTAMP NULL DEFAULT NULL,
       SBI_VERSION_IN       VARCHAR(10),
       SBI_VERSION_UP       VARCHAR(10),
       SBI_VERSION_DE       VARCHAR(10),
       META_VERSION         VARCHAR(100),
       ORGANIZATION         VARCHAR(20),       
       PRIMARY KEY (BIOBJ_ID, FUNCT_ID)
) WITHOUT OIDS;

ALTER TABLE SBI_FUNCTIONS_ORGANIZER ADD CONSTRAINT FK_SBI_FUNCTIONS_ORGANIZER_1 FOREIGN KEY (PARENT_FUNCT_ID) REFERENCES SBI_FUNCTIONS_ORGANIZER (FUNCT_ID) ON DELETE  RESTRICT;
ALTER TABLE SBI_OBJ_FUNC_ORGANIZER ADD CONSTRAINT FK_SBI_OBJ_FUNC_ORGANIZER_1 FOREIGN KEY (FUNCT_ID) REFERENCES SBI_FUNCTIONS_ORGANIZER (FUNCT_ID) ON DELETE  RESTRICT;
ALTER TABLE SBI_OBJ_FUNC_ORGANIZER ADD CONSTRAINT FK_SBI_OBJ_FUNC_ORGANIZER_2 FOREIGN KEY (BIOBJ_ID) REFERENCES SBI_OBJECTS (BIOBJ_ID) ON DELETE CASCADE ON UPDATE CASCADE;