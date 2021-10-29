-- New York City Police Crime Data Historic: 2006-2017 DB Normalization

/* CREATE & SELCT DATABASE */
DROP DATABASE IF EXISTS NYCCrimes;
CREATE DATABASE NYCCrimes;
USE NYCCrimes;

/* DELETE TABLES IF EXIST */
DROP TABLE IF EXISTS crimes_mega;

/* CREATE MEGA TABLE */
CREATE TABLE IF NOT EXISTS crimes_mega (
	cmplnt_num			INT, -- FIXME
	cmplnt_fr_dt		VARCHAR(10), -- need to convert dates to compatible types
	cmplnt_fr_tm		TIME,
	cmplnt_to_dt		VARCHAR(10),
	cmplnt_to_tm		TIME,
	addr_pct_cd			VARCHAR(10),-- FIX ME, NEED TO BE TINYINT UNSIGNED
	rpt_dt				VARCHAR(10),
	ky_cd				SMALLINT UNSIGNED,
	ofns_desc			VARCHAR(40),
	pd_cd				VARCHAR(10), -- FIXME, NEED TO BE SMALLINT UNSIGNED
	pd_desc				VARCHAR(200),
	crm_atpt_cptd_cd	VARCHAR(10),
	law_cat_cd			VARCHAR(15),
	boro_nm				VARCHAR(15),
	loc_of_occur_desc	VARCHAR(15),
	prem_typ_desc		VARCHAR(40),
	juris_desc			VARCHAR(40),
	jurisdiction_code	VARCHAR(5), -- FIXME, NEED TO BE TINYINT UNSIGNED
	parks_nm			VARCHAR(100),
	hadevelopt			VARCHAR(70),
	housing_psa			VARCHAR(10), -- FIX ME, NA values throwing things off
	x_coord_cd			VARCHAR(40), -- FIXME, NEED TO BE MEDIUMINT
	y_coord_cd			VARCHAR(40), -- FIXME
	susp_age_group		VARCHAR(10),
	susp_race			VARCHAR(40),
	susp_sex			CHAR(1),
	transit_district	VARCHAR(5), -- need to convert to tinyint
	latitude			VARCHAR(50), -- FIXME, NEED TO BE DECIMAL(12,10)
	longitude			VARCHAR(50), -- FIXME
	lat_lon				VARCHAR(40), -- need to convert to a point/geometry type
	patrol_boro			VARCHAR(40),
	station_name		VARCHAR(40),
	vic_age_group		VARCHAR(10),
	vic_race			VARCHAR(40),
	vic_sex				VARCHAR(5) -- need to convert to char(1)
) ENGINE=INNODB;

/* CREATE NORMALIZED TABLES */


/* LOAD DATA INTO MEGA TABLE*/
-- to allow the data to load without timing out, need to set DBMS connection read timeout interval (in seconds): to 0; MySQLWorkbench > Preferences > SQL Editor
-- THIS WORKS!
LOAD DATA INFILE '/Users/shaymilner/Documents/Fall 2021/CS3265/Projects/Project 2/- data/NYPD_Complaint_Data_Historic.csv' INTO TABLE crimes_mega
	FIELDS TERMINATED BY ','
	OPTIONALLY ENCLOSED BY '"'
	LINES TERMINATED BY '\n'
    IGNORE 1 LINES;

select *
from crimes_mega
limit 100;
/* POPULATING NORMALIZED TABLES FROM MEGA TABLE */