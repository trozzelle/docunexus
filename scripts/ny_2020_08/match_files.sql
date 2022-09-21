
select * from dcnxs_ny.voter_email
INTO OUTFILE  
'/mnt/volume_nyc3_01/var/lib/mysql-files/ny_voter_email.tab' 
FIELDS TERMINATED BY '\t'
LINES TERMINATED BY '\n'
;

select * from dcnxs_ny.voter_phone
INTO OUTFILE  
'/mnt/volume_nyc3_01/var/lib/mysql-files/ny_voter_phone.tab' 
FIELDS TERMINATED BY '\t'
LINES TERMINATED BY '\n'
;

select * from dcnxs_ny.voter_zip5
INTO OUTFILE  
'/mnt/volume_nyc3_01/var/lib/mysql-files/ny_voter_zip5.tab' 
FIELDS TERMINATED BY '\t'
LINES TERMINATED BY '\n'
;

select * from dcnxs_ny.voter_last_name
INTO OUTFILE  
'/mnt/volume_nyc3_01/var/lib/mysql-files/ny_voter_last_name.tab' 
FIELDS TERMINATED BY '\t'
LINES TERMINATED BY '\n'
;

select * from dcnxs_ny.voter_first_name
INTO OUTFILE  
'/mnt/volume_nyc3_01/var/lib/mysql-files/ny_voter_first_name.tab' 
FIELDS TERMINATED BY '\t'
LINES TERMINATED BY '\n'
;

select * from dcnxs_ny.voter_residence_address_v
INTO OUTFILE  
'/mnt/volume_nyc3_01/var/lib/mysql-files/ny_voter_residence_address_v.tab' 
FIELDS TERMINATED BY '\t'
LINES TERMINATED BY '\n'
;

select * from dcnxs_ny.voter_mailing_address_v
INTO OUTFILE  
'/mnt/volume_nyc3_01/var/lib/mysql-files/ny_voter_mailing_address_v.tab' 
FIELDS TERMINATED BY '\t'
LINES TERMINATED BY '\n'
;

select * from dcnxs_ny.voter_previous_address_v
INTO OUTFILE  
'/mnt/volume_nyc3_01/var/lib/mysql-files/ny_voter_previous_address_v.tab' 
FIELDS TERMINATED BY '\t'
LINES TERMINATED BY '\n'
;

