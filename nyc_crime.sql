-- New York City Police Crime Data Historic: 2006-2017 DB Normalization

/* CREATE & SELCT DATABASE */
DROP DATABASE IF EXISTS NYCCrimes;
CREATE DATABASE NYCCrimes;
USE NYCCrimes;


/* CREATE MEGA TABLE */
DROP TABLE IF EXISTS crimes_mega;
CREATE TABLE IF NOT EXISTS crimes_mega (
	cmplnt_num			INT UNSIGNED,
	cmplnt_fr_dt		VARCHAR(10), -- need to convert to DATE
	cmplnt_fr_tm		TIME,
	cmplnt_to_dt		VARCHAR(10), -- need to convert to DATE
	cmplnt_to_tm		TIME,
	addr_pct_cd			VARCHAR(5),-- need to be TINYINT UNSIGNED
	rpt_dt				VARCHAR(10), -- need to convert to DATE
	ky_cd				SMALLINT UNSIGNED,
	ofns_desc			VARCHAR(40),
	pd_cd				VARCHAR(5), -- need to be SMALLINT UNSIGNED
	pd_desc				VARCHAR(75),
	crm_atpt_cptd_cd	VARCHAR(10),
	law_cat_cd			VARCHAR(15),
	boro_nm				VARCHAR(15),
	loc_of_occur_desc	VARCHAR(15),
	prem_typ_desc		VARCHAR(30),
	juris_desc			VARCHAR(40),
	jurisdiction_code	VARCHAR(5), -- need to be TINYINT UNSIGNED
	parks_nm			VARCHAR(85),
	hadevelopt			VARCHAR(50),
	housing_psa			VARCHAR(10), -- need to be MEDIUMINT
	x_coord_cd			VARCHAR(40), -- need to convert to INT
	y_coord_cd			VARCHAR(40), -- need to convert to INT
	susp_age_group		VARCHAR(10),
	susp_race			VARCHAR(35),
	susp_sex			CHAR(1),
	transit_district	VARCHAR(5), -- need to convert to tinyint
	latitude			VARCHAR(50), -- need to convert to DECIMAL(12,10)
	longitude			VARCHAR(50), -- need to convert to DECIMAL(12,10)
	lat_lon				VARCHAR(40), -- not going to use; will reconstruct geom var from lat/long
	patrol_boro			VARCHAR(30),
	station_name		VARCHAR(35),
	vic_age_group		VARCHAR(10),
	vic_race			VARCHAR(35),
	vic_sex				CHAR(1)
) ENGINE=INNODB;

/* CREATE NORMALIZED TABLES */
-- storing unused attributes
DROP TABLE IF EXISTS unused_attrs;
CREATE TABLE IF NOT EXISTS unused_attrs (
	lat_lon				VARCHAR(40)
) ENGINE=INNODB;

-- crime type information tables
DROP TABLE IF EXISTS offense_type;
CREATE TABLE IF NOT EXISTS offense_type (
	cmplnt_num			INT UNSIGNED,
    ky_cd				SMALLINT UNSIGNED,
    ofns_desc			VARCHAR(40),
    PRIMARY KEY(cmplnt_num, ky_cd)
) ENGINE=INNODB;

DROP TABLE IF EXISTS intrnl_class;
CREATE TABLE IF NOT EXISTS intrnl_class(
	cmplnt_num			INT UNSIGNED,
    pd_cd				SMALLINT UNSIGNED,
    pd_desc				VARCHAR(75),
    crm_atpt_cptd_cd	VARCHAR(10),
    PRIMARY KEY(cmplnt_num, pd_cd) -- FIXME - MAKE THIS INTO A FOREIGN KEY?
) ENGINE=INNODB;

DROP TABLE IF EXISTS law_class;
CREATE TABLE IF NOT EXISTS law_class (
	pd_cd				SMALLINT UNSIGNED,
    law_cat_cd			VARCHAR(15),
    PRIMARY KEY(pd_cd)				-- FIXME - MAKE THIS INTO A FOREIGN KEY?
) ENGINE=INNODB;

-- complaint information tables
DROP TABLE IF EXISTS cmplnt_time_date;
CREATE TABLE IF NOT EXISTS cmplnt_time_date(
	cmplnt_num			INT UNSIGNED,
    cmplnt_fr_dt		DATE,
    cmplnt_fr_tm		TIME,
    cmplnt_to_dt		DATE,
    cmplnt_to_tm		TIME
) ENGINE=INNODB;

DROP TABLE IF EXISTS cmplnt_rpt_dt;
CREATE TABLE IF NOT EXISTS cmplnt_rpt_dt(
	cmplnt_num			INT UNSIGNED,
    cmplnt_fr_dt		DATE,
    pd_cd				SMALLINT UNSIGNED,
    rpt_dt				DATE,
    PRIMARY KEY(cmplnt_num, cmplnt_fr_dt, pd_cd) -- FIXME - MAKE FOREIGN KEYS?
) ENGINE=INNODB;

DROP TABLE IF EXISTS cmplnt_loc;
CREATE TABLE IF NOT EXISTS cmplnt_loc(
	cmplnt_num			INT UNSIGNED,
    cmplnt_fr_dt		DATE,
    boro_num			VARCHAR(15),
    loc_of_occur_desc	VARCHAR(15),
    CONSTRAINT fk_cm_num FOREIGN KEY(cmplnt_num)
		REFERENCES cmplnt_time_date(cmplnt_num),
	CONSTRAINT fk_cm_fr_dt FOREIGN KEY(cmplnt_fr_dt)
		REFERENCES cmplnt_time_date(cmplnt_fr_dt),
	PRIMARY KEY(cmplnt_num, cmplnt_fr_dt)
) ENGINE=INNODB;

DROP TABLE IF EXISTS cmplnt_housing_loc;
CREATE TABLE IF NOT EXISTS cmplnt_housing_loc(
	cmplnt_num			INT UNSIGNED,
    housing_psa			MEDIUMINT UNSIGNED,
    CONSTRAINT fk_cm_num2 FOREIGN KEY(cmplnt_num)
		REFERENCES cmplnt_time_date(cmplnt_num),
    PRIMARY KEY(cmplnt_num)
) ENGINE=INNODB;

DROP TABLE IF EXISTS housing_dev;
CREATE TABLE IF NOT EXISTS housing_dev(
	housing_psa			MEDIUMINT UNSIGNED,
    hadevelopt			VARCHAR(50),
    CONSTRAINT fk_housing FOREIGN KEY(housing_psa)
		REFERENCES cmplnt_housing_loc(housing_psa)
) ENGINE=INNODB;

DROP TABLE IF EXISTS cmplnt_prem_type;
CREATE TABLE IF NOT EXISTS cmplnt_prem_type(
	cmplnt_num			INT UNSIGNED,
    cmplnt_fr_dt		DATE,
    pd_cd				SMALLINT UNSIGNED,
    prem_typ_desc		VARCHAR(30),
    PRIMARY KEY(cmplnt_num, cmplnt_fr_dt, pd_cd) -- FIXME - FOREIGN KEY?
) ENGINE=INNODB;

DROP TABLE IF EXISTS cmplnt_trans_distr;
CREATE TABLE IF NOT EXISTS cmplnt_trans_distr(
	cmplnt_num			INT UNSIGNED,
    transit_district	TINYINT UNSIGNED,
    CONSTRAINT fk_cm_num3 FOREIGN KEY(cmplnt_num)
		REFERENCES cmplnt_time_date(cmplnt_num),
    PRIMARY KEY(cmplnt_num)
) ENGINE=INNODB;

DROP TABLE IF EXISTS cmplnt_coords;
CREATE TABLE IF NOT EXISTS cmplnt_coords(
	x_coord_cd			INT UNSIGNED,
    y_coord_cd			INT UNSIGNED,
    latitude			DECIMAL(12,10),
    longitude			DECIMAL(12,10),
    PRIMARY KEY(x_coord_cd, y_coord_cd)
) ENGINE=INNODB;

-- precint/jurisdiction loc information
DROP TABLE IF EXISTS precint_loc;
CREATE TABLE IF NOT EXISTS precint_loc( -- FIXME; may have to split this up to decrease null vals
	cmplnt_num			INT UNSIGNED,
    addr_pct_cd			TINYINT UNSIGNED,
    patrol_boro			VARCHAR(30),
    boro_nm				VARCHAR(15),
    station_name		VARCHAR(35),
    PRIMARY KEY(cmplnt_num, addr_pct_cd) -- FIXME; foreign key?
) ENGINE=INNODB;

DROP TABLE IF EXISTS juris_loc;
CREATE TABLE IF NOT EXISTS juris_loc(
	cmplnt_num			INT UNSIGNED,
    jurisdiction_code 	TINYINT UNSIGNED,
    juris_desc			VARCHAR(40),
    PRIMARY KEY(cmplnt_num, jurisdiction_code) -- FIXME; foreign key?
) ENGINE=INNODB;

-- victim and suspect information
DROP TABLE IF EXISTS vic_info;
CREATE TABLE IF NOT EXISTS vic_info(
	cmplnt_num			INT UNSIGNED, -- FIXME, MAKE INTO FOREIGN KEY
    cmplnt_to_dt		DATE, -- FIXME, MAKE INTO FOREIGN KEY?
	x_coord_cd			INT UNSIGNED, -- FIXME, MAKE INTO FOREIGN KEY FROM coords TABLE
	vic_age_group		VARCHAR(10),
	vic_race			VARCHAR(35),
	vic_sex				CHAR(1),
    PRIMARY KEY(cmplnt_num, cmplnt_to_dt, x_coord_cd)
) ENGINE=INNODB;

DROP TABLE IF EXISTS sus_info;
CREATE TABLE IF NOT EXISTS sus_info(
	cmplnt_num			INT UNSIGNED, -- FIXME, MAKE INTO FOREIGN KEY
    cmplnt_fr_dt		DATE, -- FIXME, MAKE INTO FOREIGN KEY?
    x_coord_cd			INT UNSIGNED, -- FIXME, MAKE INTO FOREIGN KEY FROM coords TABLE
	susp_race			VARCHAR(10),
    susp_sex			CHAR(1),
    PRIMARY KEY(cmplnt_num, cmplnt_fr_dt, x_coord_cd)
) ENGINE=INNODB;

DROP TABLE IF EXISTS sus_age_info;
CREATE TABLE IF NOT EXISTS sus_age_info(
	cmplnt_num			INT UNSIGNED, -- FIXME, MAKE INTO FOREIGN KEY
    cmplnt_fr_dt		DATE, -- FIXME, MAKE INTO FOREIGN KEY?
    x_coord_cd			INT UNSIGNED, -- FIXME, MAKE INTO FOREIGN KEY FROM coords TABLE
    susp_age_group 		VARCHAR(10),
    PRIMARY KEY(cmplnt_num, cmplnt_fr_dt, x_coord_cd, susp_age_group)
) ENGINE=INNODB;

/* LOAD DATA INTO MEGA TABLE*/
-- to allow the data to load without timing out, need to set DBMS connection read timeout interval (in seconds) to 0: 
-- MySQLWorkbench > Preferences > SQL Editor
-- THIS WORKS!
LOAD DATA INFILE '/Users/shaymilner/Library/Mobile Documents/com~apple~CloudDocs/Documents/Fall 2021/CS3265/Projects/Project 2/- data/NYPD_Complaint_Data_Historic.csv' INTO TABLE crimes_mega
	FIELDS TERMINATED BY ','
	OPTIONALLY ENCLOSED BY '"'
	LINES TERMINATED BY '\n'
    IGNORE 1 LINES;

-- FIX THE DATA TYPES
SET SQL_SAFE_UPDATES=0;

UPDATE crimes_mega
SET cmplnt_fr_dt = if(cmplnt_fr_dt != '', STR_TO_DATE(cmplnt_fr_dt, "%m/%d/%Y"), NULL),
	cmplnt_to_dt = if(cmplnt_to_dt != '', STR_TO_DATE(cmplnt_to_dt, "%m/%d/%Y"), NULL),
	rpt_dt = if(rpt_dt != '', STR_TO_DATE(rpt_dt, "%m/%d/%Y"), NULL),
	addr_pct_cd = if(addr_pct_cd != '', CONVERT(addr_pct_cd, UNSIGNED), NULL),
    pd_cd = if(pd_cd != '', CONVERT(pd_cd, UNSIGNED), NULL),
    jurisdiction_code = if(jurisdiction_code != '', CONVERT(jurisdiction_code, UNSIGNED), NULL),
    housing_psa = IF(housing_psa != '' AND housing_psa != NULL, CONVERT(housing_psa, UNSIGNED), NULL),
    x_coord_cd = IF(x_coord_cd != '', CONVERT(x_coord_cd, UNSIGNED), NULL),
    y_coord_cd = IF(y_coord_cd != '', CONVERT(y_coord_cd, UNSIGNED), NULL),
    transit_district = IF(transit_district != '', CONVERT(transit_district, UNSIGNED), NULL),
    latitude = if(latitude != '', CONVERT(latitude, DECIMAL(12,10)), NULL),
    longitude = if(longitude != '', CONVERT(longitude, DECIMAL(12,10)), NULL);
    
ALTER TABLE crimes_mega
    CHANGE cmplnt_fr_dt cmplnt_fr_dt DATE NULL,
    CHANGE cmplnt_to_dt cmplnt_to_dt DATE NULL,
    CHANGE rpt_dt rpt_dt DATE NULL,
    CHANGE addr_pct_cd addr_pct_cd TINYINT UNSIGNED,
    CHANGE pd_cd pd_cd SMALLINT UNSIGNED,
    CHANGE jurisdiction_code jurisdiction_code TINYINT UNSIGNED,
    CHANGE housing_psa housing_psa MEDIUMINT UNSIGNED,
    CHANGE x_coord_cd x_coord_cd INT UNSIGNED,
    CHANGE y_coord_cd y_coord_cd INT UNSIGNED,
    CHANGE transit_district transit_district TINYINT UNSIGNED,
    CHANGE latitude latitude DECIMAL(12,10),
    CHANGE longitude longitude DECIMAL(12,10);

SET SQL_SAFE_UPDATES=1;


/* POPULATING NORMALIZED TABLES FROM MEGA TABLE */
SELECT DISTINCT law_cat_cd
FROM crimes_mega
WHERE pd_cd IS NULL

