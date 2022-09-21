DROP TABLE if exists import_ny.voter;

CREATE TABLE import_ny.voter (
  last_name varchar(50),
  first_name varchar(50),
  middle_name varchar(50),
  name_suffix varchar(10),
  residence_num varchar(10),
  residence_halfnum varchar(10),
  residence_aptnum varchar(15),
  residence_pre_street_dir varchar(20),
  residence_street_name varchar(70),
  residence_post_street_dir varchar(20),
  residence_city varchar(50),
  residence_zip varchar(10),
  residence_zip_4 varchar(5),
  mailing_address_1 varchar(100),
  mailing_address_2 varchar(100),
  mailing_address_3 varchar(100),
  mailing_address_4 varchar(100),
  date_of_birth varchar(8),
  gender varchar(1),
  enrollment varchar(3),
  other_party varchar(30),
  county_code varchar(2),
  election_district varchar(3),
  legislative_district varchar(3),
  town_city varchar(30),
  ward varchar(3),
  congressional_district varchar(3),
  senate_district varchar(3),
  assembly_district varchar(3),
  last_voted_date varchar(8),
  last_voted_year varchar(4),
  last_voted_county varchar(2),
  previous_address varchar(100),
  last_registered_name varchar(150),
  county_voter_reg_num varchar(50),
  application_date varchar(8),
  application_source varchar(10),
  id_required varchar(1),
  id_required_met varchar(1),
  voter_status varchar(10),
  voter_status_reason varchar(15),
  inactive_date varchar(8),
  purge_date varchar(8),
  nys_voter_id varchar(50),
  voter_history text,
  telephone varchar(50),
  email varchar(50)
 );

\W

LOAD DATA INFILE '/mnt/volume_nyc3_01/var/lib/mysql-files/webapp/import_ny/voter.csv' IGNORE
INTO TABLE import_ny.voter
CHARACTER SET latin1
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n' -- may need to change depending on output of file -k ny.csv
-- IGNORE 1 ROWS -- uncomments in case of header row
(  last_name,
  first_name,
  middle_name,
  name_suffix,
  residence_num,
  residence_halfnum,
  residence_aptnum,
  residence_pre_street_dir,
  residence_street_name,
  residence_post_street_dir,
  residence_city,
  residence_zip,
  residence_zip_4,
  mailing_address_1,
  mailing_address_2,
  mailing_address_3,
  mailing_address_4,
  date_of_birth,
  gender,
  enrollment,
  other_party,
  county_code,
  election_district,
  legislative_district,
  town_city,
  ward,
  congressional_district,
  senate_district,
  assembly_district,
  last_voted_date,
  last_voted_year,
  last_voted_county,
  previous_address,
  last_registered_name,
  county_voter_reg_num,
  application_date,
  application_source,
  id_required,
  id_required_met,
  voter_status,
  voter_status_reason,
  inactive_date,
  purge_date,
  nys_voter_id,
  voter_history,
  telephone,
  email )
;

ALTER TABLE import_ny.voter
ADD COLUMN etl_load_id INT NOT NULL AUTO_INCREMENT,
ADD INDEX idx_nys_voter_id (nys_voter_id),
ADD INDEX idx_voter_status (voter_status),
ADD INDEX idx_purge_date (purge_date),
ADD INDEX idx_inactive_date (inactive_date),
ADD INDEX idx_last_voted_date (last_voted_date),
ADD PRIMARY KEY (etl_load_id);

select count(distinct gender) from import_ny.voter;
select count(distinct enrollment) from import_ny.voter;
select count(distinct nys_voter_id) from import_ny.voter;
select count(distinct last_name) from import_ny.voter;
select count(distinct telephone) from import_ny.voter;
select count(distinct email) from import_ny.voter;

