truncate table  dcnxs_ny.voter_data;

LOAD DATA LOCAL INFILE '/mnt/volume_nyc3_01/var/lib/mysql-files/ny_final.csv' IGNORE
INTO TABLE dcnxs_ny.voter_data
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

truncate table  dcnxs_ny.voter_data;

LOAD DATA LOCAL INFILE '/mnt/volume_nyc3_01/var/lib/mysql-files/final.csv' IGNORE
INTO TABLE dcnxs_ny.voter_data
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

truncate table  dcnxs_ny.voter_history;

LOAD DATA LOCAL INFILE '/mnt/volume_nyc3_01/var/lib/mysql-files/ny_history_final.csv' IGNORE
INTO TABLE dcnxs_ny.voter_history
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
(@col1,@col2) set 
nys_voter_id=@col1,
election_name=@col2
IGNORE 1 ROWS;
