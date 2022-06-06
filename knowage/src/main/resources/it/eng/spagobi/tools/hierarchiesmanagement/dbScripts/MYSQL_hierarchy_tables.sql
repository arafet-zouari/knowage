CREATE TABLE HIER_MASTER_TECHNICAL ( 
  `MT_ID` bigint(11) NOT NULL PRIMARY KEY, 
  `HIER_CD_T` char(20) DEFAULT NULL, 
  `HIER_NM_T` varchar(100) DEFAULT NULL, 
  `DIMENSION` char(50) DEFAULT NULL, 
  `NODE_CD_T` char(100) DEFAULT NULL, 
  `NODE_NM_T` varchar(200) DEFAULT NULL, 
  `NODE_LEV_T` smallint(6) DEFAULT NULL, 
  `GENERAL_INFO_T` TEXT NULL DEFAULT NULL,
  `PATH_CD_T` TEXT DEFAULT NULL, 
  `PATH_NM_T` TEXT DEFAULT NULL,
  `HIER_CD_M` char(20) DEFAULT NULL, 
  `HIER_NM_M` varchar(100) DEFAULT NULL, 
  `NODE_CD_M` char(100) DEFAULT NULL, 
  `NODE_NM_M` varchar(200) DEFAULT NULL, 
  `NODE_LEV_M` smallint(6) DEFAULT NULL, 
  `BACKUP` TINYINT(1) NULL DEFAULT '0',
  `BACKUP_TIMESTAMP` TIMESTAMP NULL,
  PRIMARY KEY (`MT_ID`) 
);

CREATE TABLE HIER_MASTERS_CONFIG (
	   HIER_MASTER_ID 	      INTEGER NOT NULL PRIMARY KEY,
	   HIER_CD	   		      CHAR(20) NOT NULL,
	   HIER_NM   		  	  VARCHAR(100),
	   CONFIGURATION          TEXT NULL,    	
	   TIME_IN                TIMESTAMP
);