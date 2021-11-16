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

DROP TABLE IF EXISTS law_class;
CREATE TABLE IF NOT EXISTS law_class (
	pd_cd				SMALLINT UNSIGNED,
    law_cat_cd			VARCHAR(15),
    PRIMARY KEY(pd_cd)	
) ENGINE=INNODB;

DROP TABLE IF EXISTS intrnl_class;
CREATE TABLE IF NOT EXISTS intrnl_class(
	cmplnt_num			INT UNSIGNED,
    pd_cd				SMALLINT UNSIGNED,
    pd_desc				VARCHAR(75),
    crm_atpt_cptd_cd	VARCHAR(10),
    CONSTRAINT fk_cm_num FOREIGN KEY(cmplnt_num)
 		REFERENCES offense_type(cmplnt_num),
	CONSTRAINT fk_pd_cd FOREIGN KEY(pd_cd)
		REFERENCES law_class(pd_cd),
    PRIMARY KEY(cmplnt_num, pd_cd)
) ENGINE=INNODB;


-- complaint information tables
DROP TABLE IF EXISTS cmplnt_time_date;
CREATE TABLE IF NOT EXISTS cmplnt_time_date(
	cmplnt_num			INT UNSIGNED,
    cmplnt_fr_dt		DATE,
    cmplnt_fr_tm		TIME,
    cmplnt_to_dt		DATE,
    cmplnt_to_tm		TIME,
    CONSTRAINT fk_cm_num2 FOREIGN KEY(cmplnt_num)
 		REFERENCES offense_type(cmplnt_num),
    PRIMARY KEY(cmplnt_num, cmplnt_fr_dt)
) ENGINE=INNODB;

DROP TABLE IF EXISTS cmplnt_rpt_dt;
CREATE TABLE IF NOT EXISTS cmplnt_rpt_dt(
	cmplnt_num			INT UNSIGNED,
    cmplnt_fr_dt		DATE,
    pd_cd				SMALLINT UNSIGNED,
    rpt_dt				DATE,
    CONSTRAINT fk_cm_dt FOREIGN KEY(cmplnt_num, cmplnt_fr_dt)
 		REFERENCES cmplnt_time_date(cmplnt_num, cmplnt_fr_dt),
	CONSTRAINT fk_pd_cd2 FOREIGN KEY(pd_cd)
 		REFERENCES law_class(pd_cd),
    PRIMARY KEY(cmplnt_num, cmplnt_fr_dt, pd_cd)
) ENGINE=INNODB;

DROP TABLE IF EXISTS cmplnt_loc;
CREATE TABLE IF NOT EXISTS cmplnt_loc(
	cmplnt_num			INT UNSIGNED,
    cmplnt_fr_dt		DATE,
    boro_nm			VARCHAR(15),
    loc_of_occur_desc	VARCHAR(15),
	CONSTRAINT fk_cm_dt2 FOREIGN KEY(cmplnt_num, cmplnt_fr_dt)
 		REFERENCES cmplnt_time_date(cmplnt_num, cmplnt_fr_dt),
	PRIMARY KEY(cmplnt_num, cmplnt_fr_dt)
) ENGINE=INNODB;

DROP TABLE IF EXISTS cmplnt_housing_loc;
CREATE TABLE IF NOT EXISTS cmplnt_housing_loc(
	cmplnt_num			INT UNSIGNED,
    cmplnt_fr_dt		DATE,
    housing_psa			MEDIUMINT UNSIGNED,
    CONSTRAINT fk_cm_dt3 FOREIGN KEY(cmplnt_num, cmplnt_fr_dt)
 		REFERENCES cmplnt_time_date(cmplnt_num, cmplnt_fr_dt),
    PRIMARY KEY(cmplnt_num, cmplnt_fr_dt)
) ENGINE=INNODB;

DROP TABLE IF EXISTS housing_dev;
CREATE TABLE IF NOT EXISTS housing_dev(
	cmplnt_num			INT UNSIGNED,
    cmplnt_fr_dt		DATE,
    hadevelopt			VARCHAR(50),
    CONSTRAINT fk_cm_dt4 FOREIGN KEY(cmplnt_num, cmplnt_fr_dt)
 		REFERENCES cmplnt_time_date(cmplnt_num, cmplnt_fr_dt),
    PRIMARY KEY(cmplnt_num, cmplnt_fr_dt)
) ENGINE=INNODB;

DROP TABLE IF EXISTS cmplnt_prem_type; 
CREATE TABLE IF NOT EXISTS cmplnt_prem_type(
	cmplnt_num			INT UNSIGNED,
    cmplnt_fr_dt		DATE,
    pd_cd				SMALLINT UNSIGNED,
    prem_typ_desc		VARCHAR(30),
	CONSTRAINT fk_cm_dt5 FOREIGN KEY(cmplnt_num, cmplnt_fr_dt)
 		REFERENCES cmplnt_time_date(cmplnt_num, cmplnt_fr_dt),
	CONSTRAINT fk_pd_cd3 FOREIGN KEY(pd_cd)
 		REFERENCES law_class(pd_cd),
    PRIMARY KEY(cmplnt_num, cmplnt_fr_dt, pd_cd)
) ENGINE=INNODB;

DROP TABLE IF EXISTS cmplnt_trans_distr;
CREATE TABLE IF NOT EXISTS cmplnt_trans_distr(
	cmplnt_num			INT UNSIGNED,
    transit_district	TINYINT UNSIGNED,
	CONSTRAINT fk_cm_num3 FOREIGN KEY(cmplnt_num)
 		REFERENCES offense_type(cmplnt_num),
    PRIMARY KEY(cmplnt_num)
) ENGINE=INNODB;

-- fixme below; need to fix constraints
DROP TABLE IF EXISTS cmplnt_lat_lon;
CREATE TABLE IF NOT EXISTS cmplnt_lat_lon(
	x_coord_cd			INT UNSIGNED,
    y_coord_cd			INT UNSIGNED,
    latitude			DECIMAL(12,10),
    longitude			DECIMAL(12,10),
    PRIMARY KEY(x_coord_cd, y_coord_cd)
) ENGINE=INNODB;

DROP TABLE IF EXISTS cmplnt_x_y;
CREATE TABLE IF NOT EXISTS cmplnt_x_y(
	cmplnt_num			INT UNSIGNED,
    cmplnt_fr_dt		DATE,
    x_coord_cd			INT UNSIGNED,
    y_coord_cd			INT UNSIGNED,
	CONSTRAINT fk_cm_dt6 FOREIGN KEY(cmplnt_num, cmplnt_fr_dt)
 		REFERENCES cmplnt_time_date(cmplnt_num, cmplnt_fr_dt),
	CONSTRAINT fk_x_y FOREIGN KEY(x_coord_cd, y_coord_cd)
 		REFERENCES cmplnt_lat_lon(x_coord_cd, y_coord_cd),
    PRIMARY KEY(cmplnt_num, cmplnt_fr_dt)
) ENGINE=INNODB;


-- precint/jurisdiction loc information
DROP TABLE IF EXISTS precint_loc;
CREATE TABLE IF NOT EXISTS precint_loc( 
	cmplnt_num			INT UNSIGNED,
    addr_pct_cd			TINYINT UNSIGNED,
    patrol_boro			VARCHAR(30),
    boro_nm				VARCHAR(15),
    station_name		VARCHAR(35),
	CONSTRAINT fk_cm_num4 FOREIGN KEY(cmplnt_num)
 		REFERENCES offense_type(cmplnt_num),
    PRIMARY KEY(cmplnt_num, addr_pct_cd)
) ENGINE=INNODB;

DROP TABLE IF EXISTS juris_loc;
CREATE TABLE IF NOT EXISTS juris_loc(
	cmplnt_num			INT UNSIGNED,
    jurisdiction_code 	TINYINT UNSIGNED,
    juris_desc			VARCHAR(40),
	CONSTRAINT fk_cm_num5 FOREIGN KEY(cmplnt_num)
 		REFERENCES offense_type(cmplnt_num),
    PRIMARY KEY(cmplnt_num, jurisdiction_code)
) ENGINE=INNODB;

-- victim and suspect information
DROP TABLE IF EXISTS vic_info;
CREATE TABLE IF NOT EXISTS vic_info(
	cmplnt_num			INT UNSIGNED, 
    cmplnt_to_dt		DATE,
	x_coord_cd			INT UNSIGNED, 
	vic_age_group		VARCHAR(10),
	vic_race			VARCHAR(35),
	vic_sex				CHAR(1),
	CONSTRAINT fk_cm_num6 FOREIGN KEY(cmplnt_num)
 		REFERENCES offense_type(cmplnt_num),
	CONSTRAINT fk_x FOREIGN KEY(x_coord_cd)
 		REFERENCES cmplnt_lat_lon(x_coord_cd),
    PRIMARY KEY(cmplnt_num, cmplnt_to_dt, x_coord_cd)
) ENGINE=INNODB;

DROP TABLE IF EXISTS sus_info;
CREATE TABLE IF NOT EXISTS sus_info(
	cmplnt_num			INT UNSIGNED, 
    cmplnt_fr_dt		DATE, 
    x_coord_cd			INT UNSIGNED, 
	susp_race			VARCHAR(35),
    susp_sex			CHAR(1),
	CONSTRAINT fk_cm_dt7 FOREIGN KEY(cmplnt_num, cmplnt_fr_dt)
 		REFERENCES cmplnt_time_date(cmplnt_num, cmplnt_fr_dt),
	CONSTRAINT fk_x2 FOREIGN KEY(x_coord_cd)
 		REFERENCES cmplnt_lat_lon(x_coord_cd),
    PRIMARY KEY(cmplnt_num, cmplnt_fr_dt, x_coord_cd)
) ENGINE=INNODB;

-- fixme below; need to fix constraints
DROP TABLE IF EXISTS sus_age_info;
CREATE TABLE IF NOT EXISTS sus_age_info(
	cmplnt_num			INT UNSIGNED, 
    cmplnt_fr_dt		DATE, 
    x_coord_cd			INT UNSIGNED,
    susp_age_group 		VARCHAR(10),
	CONSTRAINT fk_cm_dt_x FOREIGN KEY(cmplnt_num, cmplnt_fr_dt, x_coord_cd)
 		REFERENCES sus_info(cmplnt_num, cmplnt_fr_dt, x_coord_cd),
    PRIMARY KEY(cmplnt_num, cmplnt_fr_dt, x_coord_cd, susp_age_group)
) ENGINE=INNODB;

/* LOAD DATA INTO MEGA TABLE*/
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
	housing_psa = IF(housing_psa != '' AND housing_psa != 'NA', 
		CONVERT(replace(housing_psa,',',''), UNSIGNED), NULL),
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

/* POPULATING NORMALIZED TABLES FROM MEGA TABLE */

-- unused attributes
INSERT INTO unused_attrs
SELECT lat_lon
FROM crimes_mega;

-- offense type
INSERT INTO offense_type
SELECT DISTINCT cmplnt_num, ky_cd, ofns_desc
FROM crimes_mega;

-- law classification
INSERT INTO law_class
SELECT DISTINCT pd_cd, law_cat_cd
FROM crimes_mega
WHERE pd_cd IS NOT NULL;

-- internal classification
INSERT INTO intrnl_class
SELECT DISTINCT cmplnt_num, pd_cd, pd_desc, crm_atpt_cptd_cd
FROM crimes_mega
WHERE pd_cd IS NOT NULL;

-- complaint date & time
INSERT INTO cmplnt_time_date
SELECT DISTINCT cmplnt_num, cmplnt_fr_dt, cmplnt_fr_tm, cmplnt_to_dt, cmplnt_to_tm
FROM crimes_mega
WHERE cmplnt_fr_dt IS NOT NULL;

-- complaint report date
INSERT INTO cmplnt_rpt_dt
SELECT DISTINCT cmplnt_num, cmplnt_fr_dt, pd_cd, rpt_dt
FROM crimes_mega
WHERE cmplnt_fr_dt IS NOT NULL AND pd_cd IS NOT NULL;

-- complaint location
INSERT INTO cmplnt_loc
SELECT DISTINCT cmplnt_num, cmplnt_fr_dt, boro_nm, loc_of_occur_desc
FROM crimes_mega
WHERE cmplnt_fr_dt IS NOT NULL;

-- complaing housing psa; FIX ME: foreign key fails
INSERT INTO cmplnt_housing_loc
SELECT DISTINCT cmplnt_num, cmplnt_fr_dt, housing_psa
FROM crimes_mega
WHERE cmplnt_fr_dt IS NOT NULL AND housing_psa IS NOT NULL;

-- housing development
INSERT INTO housing_dev
SELECT DISTINCT cmplnt_num, cmplnt_fr_dt, hadevelopt
FROM crimes_mega
WHERE cmplnt_fr_dt IS NOT NULL AND hadevelopt IS NOT NULL;

-- premise type
INSERT INTO cmplnt_prem_type
SELECT DISTINCT cmplnt_num, cmplnt_fr_dt, pd_cd, prem_typ_desc
FROM crimes_mega
WHERE prem_typ_desc IS NOT NULL AND cmplnt_fr_dt IS NOT NULL AND pd_cd IS NOT NULL;

-- train station district
INSERT INTO cmplnt_trans_distr
SELECT DISTINCT cmplnt_num, transit_district
FROM crimes_mega
WHERE transit_district IS NOT NULL;

-- lat/long
INSERT INTO cmplnt_lat_lon
SELECT DISTINCT x_coord_cd, y_coord_cd, latitude, longitude
FROM crimes_mega
WHERE x_coord_cd IS NOT NULL;

-- x, y locations (fixme)
INSERT INTO cmplnt_x_y
SELECT DISTINCT cmplnt_num, cmplnt_fr_dt, x_coord_cd, y_coord_cd
FROM crimes_mega
WHERE cmplnt_fr_dt IS NOT NULL AND x_coord_cd IS NOT NULL;


-- precint/jurisdiction location
INSERT INTO precint_loc
SELECT DISTINCT cmplnt_num, addr_pct_cd, patrol_boro, boro_nm, station_name
FROM crimes_mega
WHERE addr_pct_cd IS NOT NULL;

INSERT INTO juris_loc
SELECT DISTINCT cmplnt_num, jurisdiction_code, juris_desc
FROM crimes_mega
WHERE jurisdiction_code IS NOT NULL;

-- victim  information
INSERT INTO vic_info
SELECT DISTINCT cmplnt_num, cmplnt_to_dt, x_coord_cd, vic_age_group, vic_race, vic_sex
FROM crimes_mega
WHERE cmplnt_to_dt IS NOT NULL AND x_coord_cd IS NOT NULL;

-- suspect information need to run
INSERT INTO sus_info
SELECT DISTINCT cmplnt_num, cmplnt_fr_dt, x_coord_cd, susp_race, susp_sex
FROM crimes_mega
WHERE cmplnt_fr_dt IS NOT NULL AND x_coord_cd IS NOT NULL;

INSERT INTO sus_age_info
SELECT DISTINCT cmplnt_num, cmplnt_fr_dt, x_coord_cd, susp_age_group
FROM crimes_mega
WHERE cmplnt_fr_dt IS NOT NULL AND x_coord_cd IS NOT NULL;

SET SQL_SAFE_UPDATES=1;