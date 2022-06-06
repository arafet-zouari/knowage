ALTER TABLE SBI_CATALOG_FUNCTION ADD DESCRIPTION VARCHAR NOT NULL;

ALTER TABLE SBI_PARUSE ADD COLUMN OPTIONS VARCHAR(4000) DEFAULT NULL

ALTER TABLE  SBI_GEO_MAPS ADD COLUMN HIERARCHY_NAME VARCHAR(100);
ALTER TABLE  SBI_GEO_MAPS ADD COLUMN NUM_LEVEL INTEGER;
ALTER TABLE  SBI_GEO_MAPS ADD COLUMN MEMBER_NAME VARCHAR(100);


-- SET FOREIGN_KEY_CHECKS=0;
-- delete from SBI_USER_FUNC  where name = 'CreateWorksheetFromDatasetUserFunctionality';
-- DELETE FROM SBI_OBJECTS WHERE ENGINE_ID = (select engine_id from SBI_ENGINES  where name = 'Worksheet Engine');
-- delete from SBI_ENGINES  where name = 'Worksheet Engine';
-- delete from SBI_DOMAINS where value_cd = 'WORKSHEET';
-- SET FOREIGN_KEY_CHECKS=1;

ALTER TABLE SBI_DATA_SET ADD COLUMN IS_PERSISTED_HDFS BOOLEAN DEFAULT FALSE BEFORE PERSIST_TABLE_NAME;

DELETE FROM SBI_ROLE_TYPE_USER_FUNC WHERE USER_FUNCT_ID IN (SELECT USER_FUNCT_ID FROM SBI_USER_FUNC WHERE NAME = 'ConfigManagement');
DELETE FROM SBI_ROLE_TYPE_USER_FUNC WHERE USER_FUNCT_ID IN (SELECT USER_FUNCT_ID FROM SBI_USER_FUNC WHERE NAME = 'DomainManagement');
DELETE FROM SBI_USER_FUNC WHERE NAME = 'ConfigManagement';
DELETE FROM SBI_USER_FUNC WHERE NAME = 'DomainManagement';