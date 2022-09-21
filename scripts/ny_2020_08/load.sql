create database ny_2020_08
;
DROP TABLE if exists ny_2020_08.voter_file;

CREATE TABLE ny_2020_08.voter_file (
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

LOAD DATA LOCAL INFILE '/mnt/volume_nyc3_01/var/lib/mysql-files/ny_voter_file.csv' IGNORE
INTO TABLE ny_2020_08.voter_file 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
