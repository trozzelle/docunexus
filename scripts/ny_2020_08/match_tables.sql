drop table if exists dcnxs_ny.voter_email
;
create table dcnxs_ny.voter_email as select * from  dcnxs_ny.voter_email_v
;
ALTER TABLE dcnxs_ny.voter_email 
CHANGE COLUMN nys_voter_id nys_voter_id VARCHAR(50) NOT NULL ,
ADD PRIMARY KEY (nys_voter_id),
ADD INDEX idx_email (email ASC) VISIBLE
;

drop table if exists dcnxs_ny.voter_phone
;
create table dcnxs_ny.voter_phone as select * from  dcnxs_ny.voter_phone_v
;
ALTER TABLE dcnxs_ny.voter_phone 
CHANGE COLUMN nys_voter_id nys_voter_id VARCHAR(50) NOT NULL ,
ADD PRIMARY KEY (nys_voter_id),
ADD INDEX idx_phone (phone ASC) VISIBLE
;

drop table if exists dcnxs_ny.voter_zip5
;
create table dcnxs_ny.voter_zip5 as select * from  dcnxs_ny.voter_zip5_v
;
ALTER TABLE dcnxs_ny.voter_zip5
CHANGE COLUMN nys_voter_id nys_voter_id VARCHAR(50) NOT NULL ,
ADD PRIMARY KEY (nys_voter_id),
ADD INDEX idx_zip5 (zip5 ASC) VISIBLE
;

drop table if exists dcnxs_ny.voter_first_name
;
create table dcnxs_ny.voter_first_name as select * from  dcnxs_ny.voter_first_name_v
;
ALTER TABLE dcnxs_ny.voter_first_name 
CHANGE COLUMN nys_voter_id nys_voter_id VARCHAR(50) NOT NULL ,
ADD PRIMARY KEY (nys_voter_id),
ADD INDEX idx_first_name (first_name ASC) VISIBLE
;

drop table if exists dcnxs_ny.voter_last_name
;
create table dcnxs_ny.voter_last_name as select * from  dcnxs_ny.voter_last_name_v
;
ALTER TABLE dcnxs_ny.voter_last_name 
CHANGE COLUMN nys_voter_id nys_voter_id VARCHAR(50) NOT NULL ,
ADD PRIMARY KEY (nys_voter_id),
ADD INDEX idx_last_name (last_name ASC) VISIBLE
;

drop table if exists dcnxs_ny.voter_full_name
;
create table dcnxs_ny.voter_full_name as select * from  dcnxs_ny.voter_full_name_v
;
ALTER TABLE dcnxs_ny.voter_full_name 
CHANGE COLUMN nys_voter_id nys_voter_id VARCHAR(50) NOT NULL ,
ADD PRIMARY KEY (nys_voter_id),
ADD INDEX idx_full_name (full_name ASC) VISIBLE
;

/******************************************************/

drop table if exists dcnxs_ny.voter_residence_address
;
create table dcnxs_ny.voter_residence_address as select * from  dcnxs_ny.voter_residence_address_v where 0 = 1
;
/* RUN PYTHON PROCESS IN webapp */
/* cd public_html ; python3 -c"import sys;sys.path.insert(0,\"../python-mysql\");import dcnxs_scourgify; dcnxs_scourgify.scourgify_file({'input':'/mnt/volume_nyc3_01/var/lib/mysql-files/ny_voter_residence_address_v.tab'})"  > /mnt/volume_nyc3_01/var/lib/mysql-files/ny_voter_residence_address.tab */
LOAD DATA LOCAL INFILE 
'/mnt/volume_nyc3_01/var/lib/mysql-files/ny_voter_residence_address.tab' IGNORE
INTO TABLE dcnxs_ny.voter_residence_address 
FIELDS TERMINATED BY '\t' 
LINES TERMINATED BY '\n'
;
ALTER TABLE dcnxs_ny.voter_residence_address
CHANGE COLUMN nys_voter_id nys_voter_id VARCHAR(50) NOT NULL ,
ADD PRIMARY KEY (nys_voter_id),
ADD INDEX idx_residence_address (residence_address ASC) VISIBLE
;

drop table if exists dcnxs_ny.voter_mailing_address
;
create table dcnxs_ny.voter_mailing_address as select * from  dcnxs_ny.voter_mailing_address_v where 0 = 1
;
/* RUN PYTHON PROCESS IN webapp */
/* cd public_html ; python3 -c"import sys;sys.path.insert(0,\"../python-mysql\");import dcnxs_scourgify; dcnxs_scourgify.scourgify_file({'input':'/mnt/volume_nyc3_01/var/lib/mysql-files/ny_voter_mailing_address_v.tab'})"  > /mnt/volume_nyc3_01/var/lib/mysql-files/ny_voter_mailing_address.tab */
LOAD DATA LOCAL INFILE 
'/mnt/volume_nyc3_01/var/lib/mysql-files/ny_voter_mailing_address.tab' IGNORE
INTO TABLE dcnxs_ny.voter_mailing_address 
FIELDS TERMINATED BY '\t' 
LINES TERMINATED BY '\n'
;
ALTER TABLE dcnxs_ny.voter_mailing_address
CHANGE COLUMN nys_voter_id nys_voter_id VARCHAR(50) NOT NULL ,
ADD PRIMARY KEY (nys_voter_id),
ADD INDEX idx_mailing_address (mailing_address ASC) VISIBLE
;

drop table if exists dcnxs_ny.voter_previous_address
;
create table dcnxs_ny.voter_previous_address as select * from  dcnxs_ny.voter_previous_address_v where 0 = 1
;
/* RUN PYTHON PROCESS IN webapp */
/* cd public_html ; python3 -c"import sys;sys.path.insert(0,\"../python-mysql\");import dcnxs_scourgify; dcnxs_scourgify.scourgify_file({'input':'/mnt/volume_nyc3_01/var/lib/mysql-files/ny_voter_previous_address_v.tab'})"  > /mnt/volume_nyc3_01/var/lib/mysql-files/ny_voter_previous_address.tab */
LOAD DATA LOCAL INFILE 
'/mnt/volume_nyc3_01/var/lib/mysql-files/ny_voter_previous_address.tab' IGNORE
INTO TABLE dcnxs_ny.voter_previous_address 
FIELDS TERMINATED BY '\t' 
LINES TERMINATED BY '\n'
;
ALTER TABLE dcnxs_ny.voter_previous_address
CHANGE COLUMN nys_voter_id nys_voter_id VARCHAR(50) NOT NULL ,
ADD PRIMARY KEY (nys_voter_id),
ADD INDEX idx_previous_address (previous_address ASC) VISIBLE
;
