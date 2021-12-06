/* New York City Police Crime Data Historic: 2006-2017 DB Normalization */
-- Group members: Chanteria Milner and Sneh Patel
-- CS3265 - Project 2

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

-- table that holds every complaint number
DROP TABLE IF EXISTS cmplaint_nums;
CREATE TABLE IF NOT EXISTS cmplaint_nums (
	cmplnt_num			INT UNSIGNED,
    PRIMARY KEY (cmplnt_num)
) ENGINE=INNODB;

-- crime type information tables
DROP TABLE IF EXISTS offense_type;
CREATE TABLE IF NOT EXISTS offense_type (
	cmplnt_num			INT UNSIGNED,
    ky_cd				SMALLINT UNSIGNED,
    ofns_desc			VARCHAR(40),
	CONSTRAINT fk_complaint FOREIGN KEY(cmplnt_num)
 		REFERENCES cmplaint_nums(cmplnt_num)
        ON DELETE CASCADE,
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
	CONSTRAINT fk_complaint2 FOREIGN KEY(cmplnt_num)
 		REFERENCES cmplaint_nums(cmplnt_num)
        ON DELETE CASCADE,
	CONSTRAINT fk_pd_cd FOREIGN KEY(pd_cd)
		REFERENCES law_class(pd_cd)
		ON DELETE CASCADE,
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
	CONSTRAINT fk_complaint3 FOREIGN KEY(cmplnt_num)
 		REFERENCES cmplaint_nums(cmplnt_num)
        ON DELETE CASCADE,
    PRIMARY KEY(cmplnt_num, cmplnt_fr_dt)
) ENGINE=INNODB;

DROP TABLE IF EXISTS cmplnt_rpt_dt;
CREATE TABLE IF NOT EXISTS cmplnt_rpt_dt(
	cmplnt_num			INT UNSIGNED,
    cmplnt_fr_dt		DATE,
    pd_cd				SMALLINT UNSIGNED,
    rpt_dt				DATE,
    CONSTRAINT fk_cm_dt FOREIGN KEY(cmplnt_num, cmplnt_fr_dt)
 		REFERENCES cmplnt_time_date(cmplnt_num, cmplnt_fr_dt)
        ON DELETE CASCADE,
	CONSTRAINT fk_pd_cd2 FOREIGN KEY(pd_cd)
 		REFERENCES law_class(pd_cd)
        ON DELETE CASCADE,
    PRIMARY KEY(cmplnt_num, cmplnt_fr_dt, pd_cd)
) ENGINE=INNODB;

DROP TABLE IF EXISTS cmplnt_loc;
CREATE TABLE IF NOT EXISTS cmplnt_loc(
	cmplnt_num			INT UNSIGNED,
    cmplnt_fr_dt		DATE,
    boro_nm			VARCHAR(15),
    loc_of_occur_desc	VARCHAR(15),
	CONSTRAINT fk_cm_dt2 FOREIGN KEY(cmplnt_num, cmplnt_fr_dt)
 		REFERENCES cmplnt_time_date(cmplnt_num, cmplnt_fr_dt)
        ON DELETE CASCADE,
	PRIMARY KEY(cmplnt_num, cmplnt_fr_dt)
) ENGINE=INNODB;

DROP TABLE IF EXISTS cmplnt_housing_loc;
CREATE TABLE IF NOT EXISTS cmplnt_housing_loc(
	cmplnt_num			INT UNSIGNED,
    cmplnt_fr_dt		DATE,
    housing_psa			MEDIUMINT UNSIGNED,
    CONSTRAINT fk_cm_dt3 FOREIGN KEY(cmplnt_num, cmplnt_fr_dt)
 		REFERENCES cmplnt_time_date(cmplnt_num, cmplnt_fr_dt)
        ON DELETE CASCADE,
    PRIMARY KEY(cmplnt_num, cmplnt_fr_dt)
) ENGINE=INNODB;

DROP TABLE IF EXISTS housing_dev;
CREATE TABLE IF NOT EXISTS housing_dev(
	cmplnt_num			INT UNSIGNED,
    cmplnt_fr_dt		DATE,
    hadevelopt			VARCHAR(50),
    CONSTRAINT fk_cm_dt4 FOREIGN KEY(cmplnt_num, cmplnt_fr_dt)
 		REFERENCES cmplnt_time_date(cmplnt_num, cmplnt_fr_dt)
        ON DELETE CASCADE,
    PRIMARY KEY(cmplnt_num, cmplnt_fr_dt)
) ENGINE=INNODB;

DROP TABLE IF EXISTS complaint_park;
CREATE TABLE IF NOT EXISTS complaint_park(
	cmplnt_num			INT UNSIGNED,
    cmplnt_fr_dt		DATE,
    parks_nm				VARCHAR(85),
	CONSTRAINT fk_cmplnt_dt FOREIGN KEY(cmplnt_num, cmplnt_fr_dt)
 		REFERENCES cmplnt_time_date(cmplnt_num, cmplnt_fr_dt)
        ON DELETE CASCADE,
    PRIMARY KEY(cmplnt_num, cmplnt_fr_dt)
) ENGINE = INNODB;

DROP TABLE IF EXISTS cmplnt_prem_type; 
CREATE TABLE IF NOT EXISTS cmplnt_prem_type(
	cmplnt_num			INT UNSIGNED,
    cmplnt_fr_dt		DATE,
    pd_cd				SMALLINT UNSIGNED,
    prem_typ_desc		VARCHAR(30),
	CONSTRAINT fk_cm_dt5 FOREIGN KEY(cmplnt_num, cmplnt_fr_dt)
 		REFERENCES cmplnt_time_date(cmplnt_num, cmplnt_fr_dt)
        ON DELETE CASCADE,
	CONSTRAINT fk_pd_cd3 FOREIGN KEY(pd_cd)
 		REFERENCES law_class(pd_cd)
        ON DELETE CASCADE,
    PRIMARY KEY(cmplnt_num, cmplnt_fr_dt, pd_cd)
) ENGINE=INNODB;

DROP TABLE IF EXISTS cmplnt_trans_distr;
CREATE TABLE IF NOT EXISTS cmplnt_trans_distr(
	cmplnt_num			INT UNSIGNED,
    transit_district	TINYINT UNSIGNED,
	CONSTRAINT fk_complaint4 FOREIGN KEY(cmplnt_num)
 		REFERENCES cmplaint_nums(cmplnt_num)
        ON DELETE CASCADE,
    PRIMARY KEY(cmplnt_num)
) ENGINE=INNODB;

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
 		REFERENCES cmplnt_time_date(cmplnt_num, cmplnt_fr_dt)
        ON DELETE CASCADE,
	CONSTRAINT fk_x_y FOREIGN KEY(x_coord_cd, y_coord_cd)
 		REFERENCES cmplnt_lat_lon(x_coord_cd, y_coord_cd)
        ON DELETE CASCADE,
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
	CONSTRAINT fk_complaint5 FOREIGN KEY(cmplnt_num)
 		REFERENCES cmplaint_nums(cmplnt_num)
        ON DELETE CASCADE,
    PRIMARY KEY(cmplnt_num, addr_pct_cd)
) ENGINE=INNODB;

DROP TABLE IF EXISTS juris_loc;
CREATE TABLE IF NOT EXISTS juris_loc(
	cmplnt_num			INT UNSIGNED,
    jurisdiction_code 	TINYINT UNSIGNED,
    juris_desc			VARCHAR(40),
	CONSTRAINT fk_complaint6 FOREIGN KEY(cmplnt_num)
 		REFERENCES cmplaint_nums(cmplnt_num)
        ON DELETE CASCADE,
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
	CONSTRAINT fk_complaint7 FOREIGN KEY(cmplnt_num)
 		REFERENCES cmplaint_nums(cmplnt_num)
        ON DELETE CASCADE,
	CONSTRAINT fk_x FOREIGN KEY(x_coord_cd)
 		REFERENCES cmplnt_lat_lon(x_coord_cd)
        ON DELETE CASCADE,
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
 		REFERENCES cmplnt_time_date(cmplnt_num, cmplnt_fr_dt)
        ON DELETE CASCADE,
	CONSTRAINT fk_x2 FOREIGN KEY(x_coord_cd)
 		REFERENCES cmplnt_lat_lon(x_coord_cd)
        ON DELETE CASCADE,
    PRIMARY KEY(cmplnt_num, cmplnt_fr_dt, x_coord_cd)
) ENGINE=INNODB;

DROP TABLE IF EXISTS sus_age_info;
CREATE TABLE IF NOT EXISTS sus_age_info(
	cmplnt_num			INT UNSIGNED, 
    cmplnt_fr_dt		DATE, 
    x_coord_cd			INT UNSIGNED,
    susp_age_group 		VARCHAR(10),
	CONSTRAINT fk_cm_dt_x FOREIGN KEY(cmplnt_num, cmplnt_fr_dt, x_coord_cd)
 		REFERENCES sus_info(cmplnt_num, cmplnt_fr_dt, x_coord_cd)
        ON DELETE CASCADE,
    PRIMARY KEY(cmplnt_num, cmplnt_fr_dt, x_coord_cd, susp_age_group)
) ENGINE=INNODB;

-- crime data audit table
DROP TABLE IF EXISTS crime_audit;
CREATE TABLE IF NOT EXISTS crime_audit (
	audit_id	   		INT AUTO_INCREMENT,
    cmplnt_num			INT UNSIGNED,
    delete_date			DATE,
    PRIMARY KEY(audit_id)
) ENGINE=INNODB;

/* LOAD DATA INTO MEGA TABLE*/
LOAD DATA INFILE '/Users/shaymilner/Library/Mobile Documents/com~apple~CloudDocs/Documents/Fall 2021/CS3265/Projects/Project 2/- data/NYPD_Complaint_Data_Historic.csv' INTO TABLE crimes_mega
	FIELDS TERMINATED BY ','
	OPTIONALLY ENCLOSED BY '"'
	LINES TERMINATED BY '\n'
    IGNORE 1 LINES;


/*FIXING THE DATA TYPES*/
SET SQL_SAFE_UPDATES=0;

UPDATE crimes_mega
SET cmplnt_fr_dt = IF(cmplnt_fr_dt != '', STR_TO_DATE(cmplnt_fr_dt, "%m/%d/%Y"), NULL),
	cmplnt_to_dt = IF(cmplnt_to_dt != '', STR_TO_DATE(cmplnt_to_dt, "%m/%d/%Y"), NULL),
	rpt_dt = IF(rpt_dt != '', STR_TO_DATE(rpt_dt, "%m/%d/%Y"), NULL),
    crm_atpt_cptd_cd = IF(crm_atpt_cptd_cd != '', crm_atpt_cptd_cd, NULL),
    ofns_desc = IF(ofns_desc != '', ofns_desc, NULL),
	addr_pct_cd = IF(addr_pct_cd != '', CONVERT(addr_pct_cd, UNSIGNED), NULL),
    loc_of_occur_desc = IF(loc_of_occur_desc != '', loc_of_occur_desc, NULL),
    pd_cd = IF(pd_cd != '', CONVERT(pd_cd, UNSIGNED), NULL),
    jurisdiction_code = IF(jurisdiction_code != '', CONVERT(jurisdiction_code, UNSIGNED), NULL),
	housing_psa = IF(housing_psa != '' AND housing_psa != 'NA', 
		CONVERT(replace(housing_psa,',',''), UNSIGNED), NULL),
	parks_nm = IF(parks_nm != '' AND parks_nm != 'NA', parks_nm, NULL),
	station_name = IF(station_name != '', station_name, NULL),
    patrol_boro = IF(patrol_boro != '', patrol_boro, NULL),
    boro_nm = IF(boro_nm != '', boro_nm, NULL),
    prem_typ_desc = IF(prem_typ_desc != '', prem_typ_desc, NULL),
    hadevelopt = IF(hadevelopt != '', hadevelopt, NULL),
    x_coord_cd = IF(x_coord_cd != '', CONVERT(x_coord_cd, UNSIGNED), NULL),
    y_coord_cd = IF(y_coord_cd != '', CONVERT(y_coord_cd, UNSIGNED), NULL),
    susp_age_group = IF(susp_age_group != '', susp_age_group, NULL),
    susp_race = IF(susp_race != '', susp_race, NULL),
    susp_sex = IF(susp_sex != '', susp_sex, NULL),
    transit_district = IF(transit_district != '', CONVERT(transit_district, UNSIGNED), NULL),
    latitude = IF(latitude != '', CONVERT(latitude, DECIMAL(12,10)), NULL),
    longitude = IF(longitude != '', CONVERT(longitude, DECIMAL(12,10)), NULL),
	vic_age_group = IF(vic_age_group != '', vic_age_group, NULL),
    vic_race = IF(vic_race != '', vic_race, NULL),
    vic_sex = IF(vic_sex != '', vic_sex, NULL);


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

-- complaint numbers
INSERT INTO cmplaint_nums
SELECT DISTINCT cmplnt_num
FROM crimes_mega;

-- offense type
INSERT INTO offense_type
SELECT DISTINCT cmplnt_num, ky_cd, ofns_desc
FROM crimes_mega;

-- law classification
INSERT INTO law_class
SELECT DISTINCT pd_cd, law_cat_cd
FROM crimes_mega
WHERE pd_cd IS NOT NULL AND law_cat_cd IS NOT NULL;

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

-- complaing housing psa
INSERT INTO cmplnt_housing_loc
SELECT DISTINCT cmplnt_num, cmplnt_fr_dt, housing_psa
FROM crimes_mega
WHERE cmplnt_fr_dt IS NOT NULL AND housing_psa IS NOT NULL;

-- housing development
INSERT INTO housing_dev
SELECT DISTINCT cmplnt_num, cmplnt_fr_dt, hadevelopt
FROM crimes_mega
WHERE cmplnt_fr_dt IS NOT NULL AND hadevelopt IS NOT NULL;

-- parks
INSERT INTO complaint_park
SELECT DISTINCT cmplnt_num, cmplnt_fr_dt, parks_nm
FROM crimes_mega
WHERE cmplnt_fr_dt IS NOT NULL AND parks_nm IS NOT NULL;

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

-- x, y locations 
INSERT INTO cmplnt_x_y
SELECT DISTINCT cmplnt_num, cmplnt_fr_dt, x_coord_cd, y_coord_cd
FROM crimes_mega
WHERE cmplnt_fr_dt IS NOT NULL AND x_coord_cd IS NOT NULL;

-- precint location
INSERT INTO precint_loc
SELECT DISTINCT cmplnt_num, addr_pct_cd, patrol_boro, boro_nm, station_name
FROM crimes_mega
WHERE addr_pct_cd IS NOT NULL;

-- jurisdiction location
INSERT INTO juris_loc
SELECT DISTINCT cmplnt_num, jurisdiction_code, juris_desc
FROM crimes_mega
WHERE jurisdiction_code IS NOT NULL;

-- victim  information
INSERT INTO vic_info
SELECT DISTINCT cmplnt_num, cmplnt_to_dt, x_coord_cd, vic_age_group, vic_race, vic_sex
FROM crimes_mega
WHERE cmplnt_to_dt IS NOT NULL AND x_coord_cd IS NOT NULL;

-- suspect information 
INSERT INTO sus_info
SELECT DISTINCT cmplnt_num, cmplnt_fr_dt, x_coord_cd, susp_race, susp_sex
FROM crimes_mega
WHERE cmplnt_fr_dt IS NOT NULL AND x_coord_cd IS NOT NULL;

INSERT INTO sus_age_info
SELECT DISTINCT cmplnt_num, cmplnt_fr_dt, x_coord_cd, susp_age_group
FROM crimes_mega
WHERE cmplnt_fr_dt IS NOT NULL AND x_coord_cd IS NOT NULL AND susp_age_group IS NOT NULL;

/* CREATING ADVANCED FEATURES */
/* views */
-- View to get data to verify Mega Table. Saves the user having to make a repetitive query and insulates the database from
-- user generated queries on our mega table.
DROP VIEW IF EXISTS mega; 
CREATE VIEW mega AS
SELECT cmplnt_num, cmplnt_fr_dt, cmplnt_fr_tm, 
       pd_desc, crm_atpt_cptd_cd, law_cat_cd
FROM cmplnt_time_date 
	JOIN intrnl_class USING(cmplnt_num) 
    JOIN law_class USING(pd_cd)
ORDER BY cmplnt_fr_dt DESC
LIMIT 100;

-- view to see internal law classification codes and descriptions
DROP VIEW IF EXISTS intClass;
CREATE VIEW intClass AS
SELECT DISTINCT pd_cd, pd_desc, law_cat_cd
FROM law_class JOIN intrnl_class USING(pd_cd)
ORDER BY pd_cd;

-- view to see external law classification codes and descriptions
DROP VIEW IF EXISTS extClass;
CREATE VIEW extClass AS
SELECT DISTINCT ky_cd, ofns_desc
FROM offense_type
WHERE ofns_desc IS NOT NULL
ORDER BY ky_cd;


/* stored procedures*/
-- retrieval procedure
DROP procedure IF EXISTS getComplaint;
DELIMITER //
CREATE PROCEDURE getComplaint(IN numb INT)
BEGIN
	SELECT cmplnt_num, 
		IF(cmplnt_time_date.cmplnt_fr_dt IS NULL, "UNAVAILABLE", cmplnt_time_date.cmplnt_fr_dt) AS cmplnt_fr_dt, 
        IF(cmplnt_time_date.cmplnt_to_dt IS NULL, "UNAVAILABLE", cmplnt_time_date.cmplnt_to_dt) AS cmplnt_to_dt, 
        IF(cmplnt_fr_tm IS NULL, "UNAVAILABLE", cmplnt_fr_tm) AS cmplnt_fr_tm, 
        IF(cmplnt_to_tm IS NULL, "UNAVAILABLE", cmplnt_to_tm) AS cmplnt_to_tm, 
        IF(rpt_dt IS NULL, "UNAVAILABLE", rpt_dt) AS rpt_dt, 
		IF(susp_age_group IS NULL, "UNAVAILABLE", susp_age_group) AS susp_age_group, 
		IF(susp_sex IS NULL, "UNAVAILABLE", susp_sex) AS susp_sex, 
		IF(susp_race IS NULL, "UNAVAILABLE", susp_race) AS susp_race, 
		IF(vic_age_group IS NULL, "UNAVAILABLE", vic_age_group) AS vic_age_group, 
		IF(vic_sex IS NULL, "UNAVAILABLE", vic_sex) AS vic_sex, 
		IF(vic_race IS NULL, "UNAVAILABLE", vic_race) AS vic_race,
		IF(pd_cd IS NULL, "UNAVAILABLE", pd_cd) AS pd_cd, 
        IF(ky_cd IS NULL, "UNAVAILABLE", ky_cd) AS ky_cd, 
        IF(pd_desc IS NULL, "UNAVAILABLE", pd_desc) AS pd_desc,
        IF(ofns_desc IS NULL, "UNAVAILABLE", ofns_desc) AS ofns_desc,
        IF(crm_atpt_cptd_cd IS NULL, "UNAVAILABLE", crm_atpt_cptd_cd) AS crm_atpt_cptd_cd,
        IF(law_cat_cd IS NULL, "UNAVAILABLE", law_cat_cd) AS law_cat_cd
    FROM cmplaint_nums 
		LEFT JOIN offense_type USING(cmplnt_num)
		LEFT JOIN intrnl_class USING(cmplnt_num)
		LEFT JOIN law_class USING(pd_cd)
		LEFT JOIN cmplnt_time_date USING(cmplnt_num)
		LEFT JOIN cmplnt_rpt_dt USING(cmplnt_num, cmplnt_fr_dt, pd_cd)
		LEFT JOIN precint_loc USING(cmplnt_num)
		LEFT JOIN juris_loc USING(cmplnt_num)
		LEFT JOIN vic_info USING(cmplnt_num)
		LEFT JOIN sus_info USING(cmplnt_num)
		LEFT JOIN sus_age_info USING(cmplnt_num)
	WHERE cmplaint_nums.cmplnt_num = numb;
END //
DELIMITER ;

CALL getComplaint(0);


-- Procedure Two: Find all complaint numbers linked to a certain offense type
DROP procedure IF EXISTS getOffense;
DELIMITER //
CREATE PROCEDURE getOffense(IN offense VARCHAR(50))
BEGIN
	SELECT cmplnt_num,
		pd_desc,
        cmplnt_fr_dt,
        law_cat_cd
	FROM cmplnt_time_date 
		JOIN intrnl_class USING(cmplnt_num)
		JOIN law_class USING(pd_cd)
	WHERE pd_desc = offense
	LIMIT 100;
END //
DELIMITER ;


-- get law classification
DROP procedure IF EXISTS getLaw;
DELIMITER //
CREATE PROCEDURE getLaw(IN law VARCHAR(50))
BEGIN
SELECT 	cmplnt_num,
		pd_desc,
        cmplnt_fr_dt,
        pd_cd
FROM cmplnt_time_date 
	JOIN intrnl_class USING(cmplnt_num)
    JOIN law_class USING(pd_cd)
WHERE law_cat_cd = law
LIMIT 100;
END //
DELIMITER ;


-- delete a cmplaint number
DROP procedure IF EXISTS deleteComplaint;
DELIMITER //
CREATE PROCEDURE deleteComplaint(IN comp INT UNSIGNED)
BEGIN
	DELETE FROM cmplaint_nums
	WHERE cmplnt_num = comp;

	IF comp = 0 THEN
		DELETE FROM law_class
        WHERE pd_cd = 0;
        DELETE FROM cmplnt_lat_lon
		WHERE x_coord_cd = 0;
	END IF;
END //
DELIMITER ;

-- insert procedure; handles insertion from front-end form
DROP PROCEDURE IF EXISTS insert_proc;
DELIMITER //

CREATE PROCEDURE insert_proc(IN cmplnt_num INT UNSIGNED, IN cmplnt_fr_dt VARCHAR(10), IN cmplnt_fr_tm VARCHAR(10),
    IN cmplnt_to_dt VARCHAR(10), IN cmplnt_to_tm VARCHAR(10), IN addr_pct_cd VARCHAR(5), 
    IN rpt_dt VARCHAR(10), IN ky_cd SMALLINT UNSIGNED, IN ofns_desc VARCHAR(40), 
    IN pd_cd VARCHAR(10), IN pd_desc VARCHAR(75), IN crm_atpt_cptd_cd VARCHAR(10), 
    IN law_cat_cd VARCHAR(15), IN boro_nm VARCHAR(15), IN loc_of_occur_desc VARCHAR(15), 
    IN prem_typ_desc VARCHAR(30), IN juris_desc VARCHAR(40), IN jurisdiction_code VARCHAR(5), 
    IN parks_nm VARCHAR(85), IN hadevelopt VARCHAR(50), IN housing_psa MEDIUMINT UNSIGNED, 
    IN x_coord_cd VARCHAR(40), IN y_coord_cd VARCHAR(40), IN susp_age_group VARCHAR(10), 
    IN susp_race VARCHAR(35),IN susp_sex VARCHAR(10), IN transit_district VARCHAR(5), 
    IN latitude VARCHAR(40), IN longitude VARCHAR(40), IN patrol_boro VARCHAR(30), IN station_name VARCHAR(35), 
    IN vic_age_group VARCHAR(10), IN vic_race VARCHAR(35), IN vic_sex CHAR(1))
BEGIN 
	
    -- convert into correct data types
    SET cmplnt_num = IF(cmplnt_num != '', cmplnt_num, NULL),
		cmplnt_fr_dt = IF(cmplnt_fr_dt != '', STR_TO_DATE(cmplnt_fr_dt, "%m/%d/%Y"), NULL),
		cmplnt_fr_tm = IF(cmplnt_fr_tm != '', CAST(cmplnt_fr_tm AS TIME), NULL),
		cmplnt_to_dt = IF(cmplnt_to_dt != '', STR_TO_DATE(cmplnt_to_dt, "%m/%d/%Y"), NULL),
        cmplnt_to_tm = IF(cmplnt_to_tm != '', CAST(cmplnt_to_tm AS TIME), NULL),
        addr_pct_cd = IF(addr_pct_cd != '', CONVERT(addr_pct_cd, UNSIGNED), NULL),
		rpt_dt = IF(rpt_dt != '', STR_TO_DATE(rpt_dt, "%m/%d/%Y"), NULL),
        ky_cd = IF(ky_cd != '', ky_cd, NULL),
        ofns_desc = IF(ofns_desc != '', ofns_desc, NULL),
        pd_cd = IF(pd_cd != '', CONVERT(pd_cd, UNSIGNED), NULL),
        pd_desc = IF(pd_desc != '', pd_desc, NULL),
		crm_atpt_cptd_cd = IF(crm_atpt_cptd_cd != '', crm_atpt_cptd_cd, NULL),
        law_cat_cd = IF(law_cat_cd != '', law_cat_cd, NULL),
		boro_nm = IF(boro_nm != '', boro_nm, NULL),
        loc_of_occur_desc = IF(loc_of_occur_desc != '', loc_of_occur_desc, NULL),
        prem_typ_desc = IF(prem_typ_desc != '', prem_typ_desc, NULL),
        juris_desc = IF(juris_desc != '', juris_desc, NULL),
		jurisdiction_code = IF(jurisdiction_code != '', CONVERT(jurisdiction_code, UNSIGNED), NULL),
		parks_nm = IF(parks_nm != '' AND parks_nm != 'NA', parks_nm, NULL),
        hadevelopt = IF(hadevelopt != '', hadevelopt, NULL),
        housing_psa = IF(housing_psa != '' AND housing_psa != 'NA', 
			CONVERT(replace(housing_psa,',',''), UNSIGNED), NULL),
		x_coord_cd = IF(x_coord_cd != '', CONVERT(x_coord_cd, UNSIGNED), NULL),
		y_coord_cd = IF(y_coord_cd != '', CONVERT(y_coord_cd, UNSIGNED), NULL),
        susp_age_group = IF(susp_age_group != '', susp_age_group, NULL),
		susp_race = IF(susp_race != '', susp_race, NULL),
		susp_sex = IF(susp_sex != '', susp_sex, NULL),
        transit_district = IF(transit_district != '', CONVERT(transit_district, UNSIGNED), NULL),
        latitude = IF(latitude != '', CONVERT(latitude, DECIMAL(12,10)), NULL),
		longitude = IF(longitude != '', CONVERT(longitude, DECIMAL(12,10)), NULL),
        patrol_boro = IF(patrol_boro != '', patrol_boro, NULL),
		station_name = IF(station_name != '', station_name, NULL),
		vic_age_group = IF(vic_age_group != '', vic_age_group, NULL),
		vic_race = IF(vic_race != '', vic_race, NULL),
		vic_sex = IF(vic_sex != '', vic_sex, NULL);
        
        
        -- insert the data types into the correct tables
        CALL insert_cmplaint_nums(cmplnt_num);
		CALL insert_offense_type(cmplnt_num, ky_cd, ofns_desc);
        CALL insert_law_class(pd_cd, law_cat_cd);
        CALL insert_intrnl_class(cmplnt_num, pd_cd, pd_desc, crm_atpt_cptd_cd);
        CALL insert_cmplnt_time_date(cmplnt_num, cmplnt_fr_dt, cmplnt_fr_tm, cmplnt_to_dt, cmplnt_to_tm);
		CALL insert_cmplnt_rpt_dt(cmplnt_num, cmplnt_fr_dt, pd_cd, rpt_dt);
		CALL insert_cmplnt_loc(cmplnt_num, cmplnt_fr_dt, boro_nm, loc_of_occur_desc);
        CALL insert_cmplnt_housing_loc(cmplnt_num, cmplnt_fr_dt, housing_psa);
		CALL insert_housing_dev(cmplnt_num, cmplnt_fr_dt, hadevelopt);
        CALL insert_complaint_park(cmplnt_num, cmplnt_fr_dt, parks_nm);
        CALL insert_cmplnt_prem_type(cmplnt_num, cmplnt_fr_dt, pd_cd, prem_typ_desc);
		CALL insert_cmplnt_trans_distr(cmplnt_num, transit_district);
		CALL insert_cmplnt_lat_lon(x_coord_cd, y_coord_cd, latitude, longitude);
		CALL insert_cmplnt_x_y(cmplnt_num, cmplnt_fr_dt, x_coord_cd, y_coord_cd);
        CALL insert_precint_loc(cmplnt_num, addr_pct_cd, patrol_boro, boro_nm, station_name);
        call insert_juris_loc(cmplnt_num, jurisdiction_code, juris_desc);
		CALL insert_vic_info(cmplnt_num, cmplnt_to_dt, x_coord_cd, vic_age_group, vic_race, vic_sex);
        CALL insert_sus_info(cmplnt_num, cmplnt_fr_dt, x_coord_cd, susp_race, susp_sex);
		CALL insert_sus_age_info(cmplnt_num, cmplnt_fr_dt, x_coord_cd, susp_age_group);

END //
DELIMITER ;

-- inserting: complaint_nums
DROP PROCEDURE IF EXISTS insert_cmplaint_nums;

DELIMITER //
CREATE PROCEDURE insert_cmplaint_nums(IN num INT UNSIGNED) 
BEGIN
		DECLARE CONTINUE HANDLER FOR 1062       
        SELECT "Duplicate value entered" AS msg;
		
        INSERT INTO cmplaint_nums
		VALUES(num);
END //
DELIMITER ;

-- inserting: offense_type
DROP PROCEDURE IF EXISTS insert_offense_type;

DELIMITER //
CREATE PROCEDURE insert_offense_type(IN cmplnt_num INT UNSIGNED, IN ky_cd SMALLINT UNSIGNED, 
									 IN ofns_desc VARCHAR(40)) 
BEGIN
	DECLARE CONTINUE HANDLER FOR 1062       
    SELECT "Duplicate value entered" AS msg;
    
	INSERT INTO offense_type
    VALUES(cmplnt_num, ky_cd, ofns_desc);
END //
DELIMITER ;

-- inserting: law_class
DROP PROCEDURE IF EXISTS insert_law_class;

DELIMITER //
CREATE PROCEDURE insert_law_class(IN pd_cd SMALLINT UNSIGNED, IN law_cat_cd VARCHAR(15)) 
BEGIN
	DECLARE CONTINUE HANDLER FOR 1062 
    SELECT "Duplicate value entered" AS msg;
    
	INSERT INTO law_class
    VALUES(pd_cd, law_cat_cd);
END //
DELIMITER ;

-- inserting: intrnl_class
DROP PROCEDURE IF EXISTS insert_intrnl_class;

DELIMITER //
CREATE PROCEDURE insert_intrnl_class(IN cmplnt_num INT, IN pd_cd SMALLINT UNSIGNED, IN pd_desc VARCHAR(75), 
									 IN crm_atpt_cptd_cd VARCHAR(10)) 
BEGIN
	DECLARE CONTINUE HANDLER FOR 1062 
    SELECT "Duplicate value entered" AS msg;
    
	INSERT INTO intrnl_class
    VALUES(cmplnt_num, pd_cd, pd_desc, crm_atpt_cptd_cd);
END //
DELIMITER ;

-- inserting: cmplnt_time_date
DROP PROCEDURE IF EXISTS insert_cmplnt_time_date;

DELIMITER //
CREATE PROCEDURE insert_cmplnt_time_date(IN cmplnt_num INT, IN cmplnt_fr_dt DATE, IN cmplnt_fr_tm TIME,
										IN cmplnt_to_dt DATE, IN cmplnt_to_tm TIME) 
BEGIN
	DECLARE CONTINUE HANDLER FOR 1062 
    SELECT "Duplicate value entered" AS msg;
    
	INSERT INTO cmplnt_time_date
    VALUES(cmplnt_num, cmplnt_fr_dt, cmplnt_fr_tm, cmplnt_to_dt, cmplnt_to_tm);
END //
DELIMITER ;

-- inserting: cmplnt_rpt_dt
DROP PROCEDURE IF EXISTS insert_cmplnt_rpt_dt;

DELIMITER //
CREATE PROCEDURE insert_cmplnt_rpt_dt(IN cmplnt_num INT, IN cmplnt_fr_dt DATE, IN pd_cd SMALLINT UNSIGNED,
										IN rpt_dt DATE) 
BEGIN
	DECLARE CONTINUE HANDLER FOR 1062 
    SELECT "Duplicate value entered" AS msg;
    
	INSERT INTO cmplnt_rpt_dt
    VALUES(cmplnt_num, cmplnt_fr_dt, pd_cd, rpt_dt);
END //
DELIMITER ;

-- inserting: cmplnt_loc
DROP PROCEDURE IF EXISTS insert_cmplnt_loc;

DELIMITER //
CREATE PROCEDURE insert_cmplnt_loc(IN cmplnt_num INT, IN cmplnt_fr_dt DATE, IN boro_nm VARCHAR(15),
									IN loc_of_occur_desc VARCHAR(15)) 
BEGIN
	DECLARE CONTINUE HANDLER FOR 1062 
    SELECT "Duplicate value entered" AS msg;
    
	INSERT INTO cmplnt_loc
    VALUES(cmplnt_num, cmplnt_fr_dt, boro_nm, loc_of_occur_desc);
END //
DELIMITER ;

-- inserting: cmplnt_housing_loc
DROP PROCEDURE IF EXISTS insert_cmplnt_housing_loc;

DELIMITER //
CREATE PROCEDURE insert_cmplnt_housing_loc(IN cmplnt_num INT, IN cmplnt_fr_dt DATE, IN housing_psa MEDIUMINT UNSIGNED) 
BEGIN
	DECLARE CONTINUE HANDLER FOR 1062 
    SELECT "Duplicate value entered" AS msg;
    
	INSERT INTO cmplnt_housing_loc
    VALUES(cmplnt_num, cmplnt_fr_dt, housing_psa);
END //
DELIMITER ;

-- inserting: housing_dev
DROP PROCEDURE IF EXISTS insert_housing_dev;

DELIMITER //
CREATE PROCEDURE insert_housing_dev(IN cmplnt_num INT, IN cmplnt_fr_dt DATE, IN hadevelopt VARCHAR(50)) 
BEGIN
	DECLARE CONTINUE HANDLER FOR 1062 
    SELECT "Duplicate value entered" AS msg;
    
	INSERT INTO housing_dev
    VALUES(cmplnt_num, cmplnt_fr_dt, hadevelopt);
END //
DELIMITER ;

-- inserting: complaint_park
DROP PROCEDURE IF EXISTS insert_complaint_park;

DELIMITER //
CREATE PROCEDURE insert_complaint_park(IN cmplnt_num INT, IN cmplnt_fr_dt DATE, IN park VARCHAR(85)) 
BEGIN
	DECLARE CONTINUE HANDLER FOR 1062 
    SELECT "Duplicate value entered" AS msg;
    
	INSERT INTO complaint_park
    VALUES(cmplnt_num, cmplnt_fr_dt, park);
END //
DELIMITER ;

-- inserting: cmplnt_prem_type
DROP PROCEDURE IF EXISTS insert_cmplnt_prem_type;

DELIMITER //
CREATE PROCEDURE insert_cmplnt_prem_type(IN cmplnt_num INT, IN cmplnt_fr_dt DATE, IN pd_cd SMALLINT UNSIGNED,
										IN prem_type_desc VARCHAR(30)) 
BEGIN
	DECLARE CONTINUE HANDLER FOR 1062 
    SELECT "Duplicate value entered" AS msg;
    
	INSERT INTO cmplnt_prem_type
    VALUES(cmplnt_num, cmplnt_fr_dt, pd_cd, prem_type_desc);
END //
DELIMITER ;

-- inserting: cmplnt_trans_distr
DROP PROCEDURE IF EXISTS insert_cmplnt_trans_distr;

DELIMITER //
CREATE PROCEDURE insert_cmplnt_trans_distr(IN cmplnt_num INT, IN transit_district TINYINT UNSIGNED) 
BEGIN
	DECLARE CONTINUE HANDLER FOR 1062 
    SELECT "Duplicate value entered" AS msg;
    
	INSERT INTO cmplnt_trans_distr
    VALUES(cmplnt_num, transit_district);
END //
DELIMITER ;

-- inserting: cmplnt_lat_lon
DROP PROCEDURE IF EXISTS insert_cmplnt_lat_lon;

DELIMITER //
CREATE PROCEDURE insert_cmplnt_lat_lon(IN x_coord_cd INT UNSIGNED, IN y_coord_cd INT UNSIGNED, IN latitude DECIMAL(12,10),
										IN longitude DECIMAL(12,10)) 
BEGIN
	DECLARE CONTINUE HANDLER FOR 1062 
    SELECT "Duplicate value entered" AS msg;
    
	INSERT INTO cmplnt_lat_lon
    VALUES(x_coord_cd, y_coord_cd, latitude, longitude);
END //
DELIMITER ;

-- inserting: cmplnt_x_y
DROP PROCEDURE IF EXISTS insert_cmplnt_x_y;

DELIMITER //
CREATE PROCEDURE insert_cmplnt_x_y(IN cmplnt_num INT, IN cmplnt_fr_dt DATE, IN x_coord_cd INT UNSIGNED, IN y_coord_cd INT UNSIGNED) 
BEGIN
	DECLARE CONTINUE HANDLER FOR 1062 
    SELECT "Duplicate value entered" AS msg;
    
	INSERT INTO cmplnt_x_y
    VALUES(cmplnt_num, cmplnt_fr_dt, x_coord_cd, y_coord_cd);
END //
DELIMITER ;

-- inserting: precint_loc
DROP PROCEDURE IF EXISTS insert_precint_loc;

DELIMITER //
CREATE PROCEDURE insert_precint_loc(IN cmplnt_num INT, IN addr_pct_cd TINYINT UNSIGNED, IN patrol_boro VARCHAR(30),
									IN boro_nm VARCHAR(15), station_name VARCHAR(35)) 
BEGIN
	DECLARE CONTINUE HANDLER FOR 1062 
    SELECT "Duplicate value entered" AS msg;
    
	INSERT INTO precint_loc
    VALUES(cmplnt_num, addr_pct_cd, patrol_boro, boro_nm, station_name);
END //
DELIMITER ;

-- inserting: juris_loc
DROP PROCEDURE IF EXISTS insert_juris_loc;

DELIMITER //
CREATE PROCEDURE insert_juris_loc(IN cmplnt_num INT, IN jurisdiction_code TINYINT UNSIGNED, IN juris_desc VARCHAR(40)) 
BEGIN
	DECLARE CONTINUE HANDLER FOR 1062 
    SELECT "Duplicate value entered" AS msg;
    
	INSERT INTO juris_loc
    VALUES(cmplnt_num, jurisdiction_code, juris_desc);
END //
DELIMITER ;

-- inserting: vic_info
DROP PROCEDURE IF EXISTS insert_vic_info;

DELIMITER //
CREATE PROCEDURE insert_vic_info(IN cmplnt_num INT, IN cmplnt_to_dt DATE, IN x_coord_cd INT UNSIGNED,
											IN vic_age_group VARCHAR(10), IN vic_race VARCHAR(35), IN vic_sex CHAR(1)) 
BEGIN
	DECLARE CONTINUE HANDLER FOR 1062 
    SELECT "Duplicate value entered" AS msg;
    
	INSERT INTO vic_info
    VALUES(cmplnt_num, cmplnt_to_dt, x_coord_cd, vic_age_group, vic_race, vic_sex);
END //
DELIMITER ;

-- inserting: sus_info
DROP PROCEDURE IF EXISTS insert_sus_info;

DELIMITER //
CREATE PROCEDURE insert_sus_info(IN cmplnt_num INT, IN cmplnt_fr_dt DATE, IN x_coord_cd INT UNSIGNED,
											IN susp_race VARCHAR(35), IN susp_sex CHAR(1)) 
BEGIN
	DECLARE CONTINUE HANDLER FOR 1062 
    SELECT "Duplicate value entered" AS msg;
    
	INSERT INTO sus_info
    VALUES(cmplnt_num, cmplnt_fr_dt, x_coord_cd, susp_race, susp_sex);
END //
DELIMITER ;

-- inserting: sus_age_info
DROP PROCEDURE IF EXISTS insert_sus_age_info;

DELIMITER //
CREATE PROCEDURE insert_sus_age_info(IN cmplnt_num INT, IN cmplnt_fr_dt DATE, IN x_coord_cd INT UNSIGNED,
											IN susp_age_group VARCHAR(10)) 
BEGIN
	DECLARE CONTINUE HANDLER FOR 1062 
    SELECT "Duplicate value entered" AS msg;
    
	INSERT INTO sus_age_info
    VALUES(cmplnt_num, cmplnt_fr_dt, x_coord_cd, susp_age_group);
END //
DELIMITER ;

-- update procedure; handles updates from front-end form
DROP PROCEDURE IF EXISTS update_proc;
DELIMITER //

CREATE PROCEDURE update_proc(IN cmplnt_num INT UNSIGNED, IN cmplnt_fr_dt VARCHAR(10), IN cmplnt_fr_tm VARCHAR(10),
    IN cmplnt_to_dt VARCHAR(10), IN cmplnt_to_tm VARCHAR(10), IN addr_pct_cd VARCHAR(5), 
    IN rpt_dt VARCHAR(10), IN ky_cd SMALLINT UNSIGNED, IN ofns_desc VARCHAR(40), 
    IN pd_cd VARCHAR(10), IN pd_desc VARCHAR(75), IN crm_atpt_cptd_cd VARCHAR(10), 
    IN law_cat_cd VARCHAR(15), IN boro_nm VARCHAR(15), IN loc_of_occur_desc VARCHAR(15), 
    IN prem_typ_desc VARCHAR(30), IN juris_desc VARCHAR(40), IN jurisdiction_code VARCHAR(5), 
    IN parks_nm VARCHAR(85), IN hadevelopt VARCHAR(50), IN housing_psa MEDIUMINT UNSIGNED, 
    IN x_coord_cd VARCHAR(40), IN y_coord_cd VARCHAR(40), IN susp_age_group VARCHAR(10), 
    IN susp_race VARCHAR(35),IN susp_sex VARCHAR(10), IN transit_district VARCHAR(5), 
    IN latitude VARCHAR(40), IN longitude VARCHAR(40), IN patrol_boro VARCHAR(30), IN station_name VARCHAR(35), 
    IN vic_age_group VARCHAR(10), IN vic_race VARCHAR(35), IN vic_sex CHAR(1))
BEGIN 
    declare exist BOOL DEFAULT FALSE;
    declare num int unsigned;
    set num = cmplnt_num;
    
    -- checking if complaint number to update exists in dataset already
    select *
    into exist
    from cmplaint_nums
    where cmplnt_num = num
    limit 1;
        
	-- convert into correct data types
    SET cmplnt_num = IF(cmplnt_num = '', NULL, cmplnt_num),
		cmplnt_fr_dt = IF(cmplnt_fr_dt != '', STR_TO_DATE(cmplnt_fr_dt, "%m/%d/%Y"), NULL),
		cmplnt_fr_tm = IF(cmplnt_fr_tm != '', CAST(cmplnt_fr_tm AS TIME), NULL),
		cmplnt_to_dt = IF(cmplnt_to_dt != '', STR_TO_DATE(cmplnt_to_dt, "%m/%d/%Y"), NULL),
        cmplnt_to_tm = IF(cmplnt_to_tm != '', CAST(cmplnt_to_tm AS TIME), NULL),
        addr_pct_cd = IF(addr_pct_cd != '', CONVERT(addr_pct_cd, UNSIGNED), NULL),
		rpt_dt = IF(rpt_dt != '', STR_TO_DATE(rpt_dt, "%m/%d/%Y"), NULL),
        ky_cd = IF(ky_cd != '', ky_cd, NULL),
        ofns_desc = IF(ofns_desc != '', ofns_desc, NULL),
        pd_cd = IF(pd_cd != '', CONVERT(pd_cd, UNSIGNED), NULL),
        pd_desc = IF(pd_desc != '', pd_desc, NULL),
		crm_atpt_cptd_cd = IF(crm_atpt_cptd_cd != '', crm_atpt_cptd_cd, NULL),
        law_cat_cd = IF(law_cat_cd != '', law_cat_cd, NULL),
		boro_nm = IF(boro_nm != '', boro_nm, NULL),
        loc_of_occur_desc = IF(loc_of_occur_desc != '', loc_of_occur_desc, NULL),
        prem_typ_desc = IF(prem_typ_desc != '', prem_typ_desc, NULL),
        juris_desc = IF(juris_desc != '', juris_desc, NULL),
		jurisdiction_code = IF(jurisdiction_code != '', CONVERT(jurisdiction_code, UNSIGNED), NULL),
		parks_nm = IF(parks_nm != '' AND parks_nm != 'NA', parks_nm, NULL),
        hadevelopt = IF(hadevelopt != '', hadevelopt, NULL),
        housing_psa = IF(housing_psa != '' AND housing_psa != 'NA', 
			CONVERT(replace(housing_psa,',',''), UNSIGNED), NULL),
		x_coord_cd = IF(x_coord_cd != '', CONVERT(x_coord_cd, UNSIGNED), NULL),
		y_coord_cd = IF(y_coord_cd != '', CONVERT(y_coord_cd, UNSIGNED), NULL),
        susp_age_group = IF(susp_age_group != '', susp_age_group, NULL),
		susp_race = IF(susp_race != '', susp_race, NULL),
		susp_sex = IF(susp_sex != '', susp_sex, NULL),
        transit_district = IF(transit_district != '', CONVERT(transit_district, UNSIGNED), NULL),
        latitude = IF(latitude != '', CONVERT(latitude, DECIMAL(12,10)), NULL),
		longitude = IF(longitude != '', CONVERT(longitude, DECIMAL(12,10)), NULL),
        patrol_boro = IF(patrol_boro != '', patrol_boro, NULL),
		station_name = IF(station_name != '', station_name, NULL),
		vic_age_group = IF(vic_age_group != '', vic_age_group, NULL),
		vic_race = IF(vic_race != '', vic_race, NULL),
		vic_sex = IF(vic_sex != '', vic_sex, NULL);
                
		IF cmplnt_num IS NOT NULL AND exist != 0 THEN  
        -- update the data types into the correct tables; only allows updates for complaint information
        -- (not offense descriptions, etc.)
			CALL update_cmplnt_time_date(cmplnt_num, cmplnt_fr_tm, cmplnt_to_dt, cmplnt_to_tm);
			CALL update_cmplnt_rpt_dt(cmplnt_num, rpt_dt);
			CALL update_cmplnt_loc(cmplnt_num, boro_nm, loc_of_occur_desc);
			CALL update_cmplnt_housing_loc(cmplnt_num, housing_psa);
			CALL update_housing_dev(cmplnt_num, hadevelopt);
			CALL update_complaint_park(cmplnt_num, parks_nm);
			CALL update_cmplnt_prem_type(cmplnt_num, prem_typ_desc);
			CALL update_cmplnt_trans_distr(cmplnt_num, transit_district);
			CALL update_precint_loc(cmplnt_num, patrol_boro, boro_nm, station_name);
			CALL update_vic_info(cmplnt_num, vic_age_group, vic_race, vic_sex);
			CALL update_sus_info(cmplnt_num, susp_race, susp_sex);
			CALL update_sus_age_info(cmplnt_num, susp_age_group);
        -- calls inserts if the complaint number is null
		ELSE 
			CALL insert_proc(cmplnt_num, cmplnt_fr_dt, cmplnt_fr_tm, cmplnt_to_dt, 
            cmplnt_to_tm, addr_pct_cd,rpt_dt, ky_cd, ofns_desc, pd_cd,pd_desc,crm_atpt_cptd_cd, 
            law_cat_cd, boro_nm,loc_of_occur_desc,prem_typ_desc,juris_desc, jurisdiction_code,
            parks_nm, hadevelopt, housing_psa, x_coord_cd , y_coord_cd, susp_age_group,
            susp_race, susp_sex, transit_district, latitude, longitude, patrol_boro, station_name,
            vic_age_group, vic_race, vic_sex);
		END IF;

END //
DELIMITER ;

-- updating: cmplnt_time_date
DROP PROCEDURE IF EXISTS update_cmplnt_time_date;

DELIMITER //
CREATE PROCEDURE update_cmplnt_time_date(IN num INT, IN fr_tm TIME, IN to_dt DATE, IN to_tm TIME) 
BEGIN
	UPDATE cmplnt_time_date
	SET cmplnt_fr_tm = IF(fr_tm IS NULL, cmplnt_fr_tm, fr_tm),
        cmplnt_to_dt = IF(to_dt IS NULL, cmplnt_to_dt, to_dt),
        cmplnt_to_tm = IF(to_tm IS NULL, cmplnt_to_tm, to_tm)
    WHERE cmplnt_num = num;
END //
DELIMITER ;

-- updating: cmplnt_rpt_dt
DROP PROCEDURE IF EXISTS update_cmplnt_rpt_dt;

DELIMITER //
CREATE PROCEDURE update_cmplnt_rpt_dt(IN num INT, IN rpt DATE) 
BEGIN
	UPDATE cmplnt_rpt_dt
    SET rpt_dt = IF(rpt IS NULL, rpt_dt, rpt)
    WHERE cmplnt_num = num;
END //
DELIMITER ;

-- updating: cmplnt_loc
DROP PROCEDURE IF EXISTS update_cmplnt_loc;

DELIMITER //
CREATE PROCEDURE update_cmplnt_loc(IN num INT, IN boro VARCHAR(15),
									IN loc_desc VARCHAR(15)) 
BEGIN
	UPDATE cmplnt_loc
    SET boro_nm = IF(boro IS NULL, boro_nm, boro),
		loc_of_occur_desc = IF(loc_desc IS NULL, loc_of_occur_desc, loc_desc)
    WHERE cmplnt_num = num;
END //
DELIMITER ;

-- updating: cmplnt_housing_loc
DROP PROCEDURE IF EXISTS update_cmplnt_housing_loc;

DELIMITER //
CREATE PROCEDURE update_cmplnt_housing_loc(IN num INT, IN psa MEDIUMINT UNSIGNED) 
BEGIN
	UPDATE cmplnt_housing_loc
    SET housing_psa = IF(psa IS NULL, housing_psa, psa)
    WHERE cmplnt_num = num;
END //
DELIMITER ;

-- updating: housing_dev
DROP PROCEDURE IF EXISTS update_housing_dev;

DELIMITER //
CREATE PROCEDURE update_housing_dev(IN num INT, IN develop VARCHAR(50)) 
BEGIN
	UPDATE housing_dev
    SET hadevelopt = IF(develop IS NULL, hadevelopt, develop)
    WHERE cmplnt_num = num;
END //
DELIMITER ;

-- updating: complaint_park
DROP PROCEDURE IF EXISTS update_complaint_park;

DELIMITER //
CREATE PROCEDURE update_complaint_park(IN num INT, IN p VARCHAR(85)) 
BEGIN
	UPDATE complaint_park
    SET parks_nm = IF(p IS NULL, parks_nm, p)
    WHERE cmplnt_num = num;
END //
DELIMITER ;

-- updating: cmplnt_prem_type
DROP PROCEDURE IF EXISTS update_cmplnt_prem_type;

DELIMITER //
CREATE PROCEDURE update_cmplnt_prem_type(IN num INT, IN prem VARCHAR(30)) 
BEGIN
	UPDATE cmplnt_prem_type
    SET prem_typ_desc = IF(prem IS NULL, prem_typ_desc, prem)
    WHERE cmplnt_num = num;
END //
DELIMITER ;

-- updating: cmplnt_trans_distr
DROP PROCEDURE IF EXISTS update_cmplnt_trans_distr;

DELIMITER //
CREATE PROCEDURE update_cmplnt_trans_distr(IN num INT, IN transit TINYINT UNSIGNED) 
BEGIN
	UPDATE cmplnt_trans_distr
    SET transit_district = IF(transit IS NULL, transit_district, transit)
    WHERE cmplnt_num = num;
END //
DELIMITER ;

-- updating: precint_loc
DROP PROCEDURE IF EXISTS update_precint_loc;

DELIMITER //
CREATE PROCEDURE update_precint_loc(IN num INT, IN boro VARCHAR(30),
									IN nm VARCHAR(15), station VARCHAR(35)) 
BEGIN
	UPDATE precint_loc
    SET patrol_boro = IF(boro IS NULL, patrol_boro, boro),
		boro_nm = IF(nm IS NULL, boro_nm, nm),
		station_name = IF(station IS NULL, station_name, station)
    WHERE cmplnt_num = num;
END //
DELIMITER ;


-- updating: vic_info
DROP PROCEDURE IF EXISTS update_vic_info;

DELIMITER //
CREATE PROCEDURE update_vic_info(IN num INT, IN age_group VARCHAR(10), 
								IN race VARCHAR(35), IN sex CHAR(1)) 
BEGIN
	UPDATE vic_info
    SET vic_age_group = IF(age_group IS NULL, vic_age_group, age_group),
		vic_race = IF(race IS NULL, vic_race, race),
        vic_sex = IF(sex IS NULL, vic_sex, sex)
    WHERE cmplnt_num = num;
END //
DELIMITER ;


-- updating: sus_info
DROP PROCEDURE IF EXISTS update_sus_info;

DELIMITER //
CREATE PROCEDURE update_sus_info(IN num INT, IN race VARCHAR(35), IN sex CHAR(1)) 
BEGIN
	UPDATE sus_info
    SET susp_race = IF(race IS NULL, susp_race, race),
		susp_sex = IF(sex IS NULL, susp_sex, sex)
    WHERE cmplnt_num = num;
END //
DELIMITER ;

-- updating: sus_age_info
DROP PROCEDURE IF EXISTS update_sus_age_info;

DELIMITER //
CREATE PROCEDURE update_sus_age_info(IN num INT, IN age_group VARCHAR(10)) 
BEGIN
	UPDATE sus_age_info
    SET susp_age_group = IF(age_group IS NULL, susp_age_group, age_group)
    WHERE cmplnt_num = num;
END //
DELIMITER ;

/* TRIGGERS */
-- delete trigger
DROP TRIGGER IF EXISTS cmplaintnums_after_delete;
DELIMITER //

CREATE TRIGGER cmplaintnums_after_delete
AFTER DELETE
ON cmplaint_nums
FOR EACH ROW
BEGIN
	INSERT INTO crime_audit(cmplnt_num, delete_date)
    VALUES (OLD.cmplnt_num, NOW());
END //

DELIMITER ;

-- insert triggers
-- cmplaint_nums
DROP TRIGGER IF EXISTS cmplaintnums_before_insert;
DELIMITER //

CREATE TRIGGER cmplaintnums_before_insert
BEFORE INSERT
ON cmplaint_nums
FOR EACH ROW
BEGIN
	IF NEW.cmplnt_num IS NULL THEN
		SET NEW.cmplnt_num = 0;
	END IF;
END // 

DELIMITER ;


-- offense_type
DROP TRIGGER IF EXISTS offensetype_before_insert;
DELIMITER //

CREATE TRIGGER offensetype_before_insert
BEFORE INSERT
ON offense_type
FOR EACH ROW
BEGIN
	IF NEW.cmplnt_num IS NULL THEN
		SET NEW.cmplnt_num = 0;
	END IF;
    
    IF NEW.ky_cd IS NULL THEN
		SET NEW.ky_cd = 0;
	END IF;
    
    IF (NEW.cmplnt_num = 0 OR NEW.ky_cd = 0) AND NEW.ofns_desc IS NULL THEN
		SET NEW.ofns_desc = "UNAVAILABLE";
	END IF;
    
END // 
DELIMITER ;

-- law_class
DROP TRIGGER IF EXISTS lawclass_before_insert;
DELIMITER //

CREATE TRIGGER lawclass_before_insert
BEFORE INSERT
ON law_class
FOR EACH ROW
BEGIN
    IF NEW.pd_cd IS NULL THEN
		SET NEW.pd_cd = 0;
	END IF;
    
    IF NEW.law_cat_cd IS NULL THEN
		SET NEW.law_cat_cd = "UNAVAILABLE";
	END IF;

END // 
DELIMITER ;


-- intrnl_class
DROP TRIGGER IF EXISTS intrnlclass_before_insert;
DELIMITER //

CREATE TRIGGER intrnlclass_before_insert
BEFORE INSERT
ON intrnl_class
FOR EACH ROW
BEGIN
    IF NEW.cmplnt_num IS NULL THEN
		SET NEW.cmplnt_num = 0;
	END IF;
    
    IF NEW.pd_cd IS NULL THEN
		SET NEW.pd_cd = 0;
	END IF;
END // 
DELIMITER ;

-- cmplnt_time_date
DROP TRIGGER IF EXISTS cmplnttimedate_before_insert;
DELIMITER //

CREATE TRIGGER cmplnttimedate_before_insert
BEFORE INSERT
ON cmplnt_time_date
FOR EACH ROW
BEGIN
    IF NEW.cmplnt_num IS NULL THEN
		SET NEW.cmplnt_num = 0;
	END IF;
    
    IF NEW.cmplnt_fr_dt IS NULL THEN
		SET NEW.cmplnt_fr_dt = NOW();
	END IF;
END // 
DELIMITER ;

-- cmplnt_rpt_dt
DROP TRIGGER IF EXISTS cmplntrptdt_before_insert;
DELIMITER //

CREATE TRIGGER cmplntrptdt_before_insert
BEFORE INSERT
ON cmplnt_rpt_dt
FOR EACH ROW
BEGIN
    IF NEW.cmplnt_num IS NULL THEN
		SET NEW.cmplnt_num = 0;
	END IF;
    
    IF NEW.pd_cd IS NULL THEN
		SET NEW.pd_cd = 0;
	END IF;
    
    IF NEW.cmplnt_fr_dt IS NULL THEN
		SET NEW.cmplnt_fr_dt = NOW();
	END IF;
END // 
DELIMITER ;

-- cmplnt_loc
DROP TRIGGER IF EXISTS cmplntloc_before_insert;
DELIMITER //

CREATE TRIGGER cmplntloc_before_insert
BEFORE INSERT
ON cmplnt_loc
FOR EACH ROW
BEGIN
    IF NEW.cmplnt_num IS NULL THEN
		SET NEW.cmplnt_num = 0;
	END IF;

    IF NEW.cmplnt_fr_dt IS NULL THEN
		SET NEW.cmplnt_fr_dt = NOW();
	END IF;
END // 
DELIMITER ;

-- cmplnt_housing_loc
DROP TRIGGER IF EXISTS cmplnthousingloc_before_insert;
DELIMITER //

CREATE TRIGGER cmplnthousingloc_before_insert
BEFORE INSERT
ON cmplnt_housing_loc
FOR EACH ROW
BEGIN
	DECLARE new_housing_psa MEDIUMINT UNSIGNED;
    
    IF NEW.cmplnt_num IS NULL THEN
		SET NEW.cmplnt_num = 0;
	END IF;

    IF NEW.cmplnt_fr_dt IS NULL THEN
		SET NEW.cmplnt_fr_dt = NOW();
	END IF;
    
    IF (NEW.cmplnt_num = 0 OR NEW.cmplnt_fr_dt = NOW()) AND NEW.housing_psa IS NULL THEN
		SET NEW.housing_psa = 0;
	END IF;
		
END // 
DELIMITER ;

-- housing_dev
DROP TRIGGER IF EXISTS housingdev_before_insert;
DELIMITER //

CREATE TRIGGER housingdev_before_insert
BEFORE INSERT
ON housing_dev
FOR EACH ROW
BEGIN
    IF NEW.cmplnt_num IS NULL THEN
		SET NEW.cmplnt_num = 0;
	END IF;

    IF NEW.cmplnt_fr_dt IS NULL THEN
		SET NEW.cmplnt_fr_dt = NOW();
	END IF;
    
    IF (NEW.cmplnt_num = 0 OR NEW.cmplnt_fr_dt = NOW()) AND NEW.hadevelopt IS NULL THEN
		SET NEW.hadevelopt = "UNAVAILABLE";
	END IF;
END // 
DELIMITER ;

-- complaint_park
DROP TRIGGER IF EXISTS complaintpark_before_insert;
DELIMITER //

CREATE TRIGGER complaintpark_before_insert
BEFORE INSERT
ON complaint_park
FOR EACH ROW
BEGIN
    IF NEW.cmplnt_num IS NULL THEN
		SET NEW.cmplnt_num = 0;
	END IF;

    IF NEW.cmplnt_fr_dt IS NULL THEN
		SET NEW.cmplnt_fr_dt = NOW();
	END IF;
    
    IF (NEW.cmplnt_num = 0 OR NEW.cmplnt_fr_dt = NOW()) AND NEW.parks_nm IS NULL THEN
		SET NEW.parks_nm = "UNAVAILABLE";
	END IF;
END // 
DELIMITER ;

-- cmplnt_prem_type
DROP TRIGGER IF EXISTS cmplntpremtype_before_insert;
DELIMITER //

CREATE TRIGGER cmplntpremtype_before_insert
BEFORE INSERT
ON cmplnt_prem_type
FOR EACH ROW
BEGIN
    IF NEW.cmplnt_num IS NULL THEN
		SET NEW.cmplnt_num = 0;
	END IF;

    IF NEW.cmplnt_fr_dt IS NULL THEN
		SET NEW.cmplnt_fr_dt = NOW();
	END IF;
    
    IF NEW.pd_cd IS NULL THEN
		SET NEW.pd_cd = 0;
	END IF;
    
    IF (NEW.cmplnt_num = 0 OR NEW.cmplnt_fr_dt = NOW() OR NEW.pd_cd = 0) AND NEW.prem_typ_desc IS NULL THEN
		SET NEW.prem_typ_desc = "UNAVAILABLE";
	END IF;
END // 
DELIMITER ;

-- cmplnt_trans_distr
DROP TRIGGER IF EXISTS cmplnttransdistr_before_insert;
DELIMITER //

CREATE TRIGGER cmplnttransdistr_before_insert
BEFORE INSERT
ON cmplnt_trans_distr
FOR EACH ROW
BEGIN
    IF NEW.cmplnt_num IS NULL THEN
		SET NEW.cmplnt_num = 0;
	END IF;
    
    IF NEW.cmplnt_num = 0 AND NEW.transit_district IS NULL THEN
		SET NEW.transit_district = 0;
	END IF;

END // 
DELIMITER ;

-- cmplnt_lat_lon
DROP TRIGGER IF EXISTS cmplntlatlon_before_insert;
DELIMITER //

CREATE TRIGGER cmplntlatlon_before_insert
BEFORE INSERT
ON cmplnt_lat_lon
FOR EACH ROW
BEGIN
    IF NEW.x_coord_cd IS NULL THEN
		SET NEW.x_coord_cd = 0;
	END IF;
    
    IF NEW.y_coord_cd IS NULL THEN
		SET NEW.y_coord_cd = 0;
	END IF;
    
	IF NEW.latitude IS NULL THEN
		SET NEW.latitude = 0;
	END IF;
	IF NEW.longitude IS NULL THEN
		SET NEW.longitude = 0;
	END IF;

END // 
DELIMITER ;

-- cmplnt_x_y
DROP TRIGGER IF EXISTS cmplntxy_before_insert;
DELIMITER //

CREATE TRIGGER cmplntxy_before_insert
BEFORE INSERT
ON cmplnt_x_y
FOR EACH ROW
BEGIN
    IF NEW.cmplnt_num IS NULL THEN
		SET NEW.cmplnt_num = 0;
	END IF;

    IF NEW.cmplnt_fr_dt IS NULL THEN
		SET NEW.cmplnt_fr_dt = NOW();
	END IF;
    
    IF NEW.x_coord_cd IS NULL THEN
		SET NEW.x_coord_cd = 0;
	END IF;
    
    IF NEW.y_coord_cd IS NULL THEN
		SET NEW.y_coord_cd = 0;
	END IF;

END // 
DELIMITER ;

-- precint_loc
DROP TRIGGER IF EXISTS precintloc_before_insert;
DELIMITER //

CREATE TRIGGER precintloc_before_insert
BEFORE INSERT
ON precint_loc
FOR EACH ROW
BEGIN
    IF NEW.cmplnt_num IS NULL THEN
		SET NEW.cmplnt_num = 0;
	END IF;

    IF NEW.addr_pct_cd IS NULL THEN
		SET NEW.addr_pct_cd = 0;
	END IF;
END // 
DELIMITER ;

-- juris_loc
DROP TRIGGER IF EXISTS jurisloc_before_insert;
DELIMITER //

CREATE TRIGGER jurisloc_before_insert
BEFORE INSERT
ON juris_loc
FOR EACH ROW
BEGIN
    IF NEW.cmplnt_num IS NULL THEN
		SET NEW.cmplnt_num = 0;
	END IF;

    IF NEW.jurisdiction_code IS NULL THEN
		SET NEW.jurisdiction_code = 0;
	END IF;
END // 
DELIMITER ;

-- vic_info
DROP TRIGGER IF EXISTS vicinfo_before_insert;
DELIMITER //

CREATE TRIGGER vicinfo_before_insert
BEFORE INSERT
ON vic_info
FOR EACH ROW
BEGIN
    IF NEW.cmplnt_num IS NULL THEN
		SET NEW.cmplnt_num = 0;
	END IF;

    IF NEW.cmplnt_to_dt IS NULL THEN
		SET NEW.cmplnt_to_dt = NOW();
	END IF;
    
    IF NEW.x_coord_cd IS NULL THEN
		SET NEW.x_coord_cd = 0;
	END IF;
END // 
DELIMITER ;

-- sus_info
DROP TRIGGER IF EXISTS susinfo_before_insert;
DELIMITER //

CREATE TRIGGER susinfo_before_insert
BEFORE INSERT
ON sus_info
FOR EACH ROW
BEGIN
    IF NEW.cmplnt_num IS NULL THEN
		SET NEW.cmplnt_num = 0;
	END IF;

    IF NEW.cmplnt_fr_dt IS NULL THEN
		SET NEW.cmplnt_fr_dt = NOW();
	END IF;
    
    IF NEW.x_coord_cd IS NULL THEN
		SET NEW.x_coord_cd = 0;
	END IF;
END // 
DELIMITER ;

-- sus_age_info
DROP TRIGGER IF EXISTS susageinfo_before_insert;
DELIMITER //

CREATE TRIGGER susageinfo_before_insert
BEFORE INSERT
ON sus_age_info
FOR EACH ROW
BEGIN
    IF NEW.cmplnt_num IS NULL THEN
		SET NEW.cmplnt_num = 0;
	END IF;

    IF NEW.cmplnt_fr_dt IS NULL THEN
		SET NEW.cmplnt_fr_dt = NOW();
	END IF;
    
    IF NEW.x_coord_cd IS NULL THEN
		SET NEW.x_coord_cd = 0;
	END IF;

    IF NEW.susp_age_group IS NULL THEN
		SET NEW.susp_age_group = 'UNKNOWN';
	END IF;
    
END // 
DELIMITER ;


SET SQL_SAFE_UPDATES=1;