select "last_name","first_name","middle_name","name_suffix","residence_num","residence_halfnum","residence_aptnum","residence_pre_street_dir","residence_street_name","residence_post_street_dir","residence_city","residence_zip","residence_zip_4","mailing_address_1","mailing_address_2","mailing_address_3","mailing_address_4","date_of_birth","gender","enrollment","other_party","county_code","election_district","legislative_district","town_city","ward","congressional_district","senate_district","assembly_district","last_voted_date","last_voted_year","last_voted_county","previous_address","last_registered_name","county_voter_reg_num","application_date","application_source","id_required","id_required_met","voter_status","voter_status_reason","inactive_date","purge_date","nys_voter_id","telephone","email"
union all
select * 
from ny_2020_08.final
INTO OUTFILE  
'/mnt/volume_nyc3_01/var/lib/mysql-files/ny_final.csv' 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
;


select "last_name","first_name","middle_name","name_suffix","residence_num","residence_halfnum","residence_aptnum","residence_pre_street_dir","residence_street_name","residence_post_street_dir","residence_city","residence_zip","residence_zip_4","mailing_address_1","mailing_address_2","mailing_address_3","mailing_address_4","date_of_birth","gender","enrollment","other_party","county_code","election_district","legislative_district","town_city","ward","congressional_district","senate_district","assembly_district","last_voted_date","last_voted_year","last_voted_county","previous_address","last_registered_name","county_voter_reg_num","application_date","application_source","id_required","id_required_met","voter_status","voter_status_reason","inactive_date","purge_date","nys_voter_id","telephone","email"
union all
select * 
from ny_2020_08.final
INTO OUTFILE  
'/mnt/volume_nyc3_01/var/lib/mysql-files/final.csv' 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
;

select "nys_voter_id","election_name"
union all
select * 
from ny_2020_08.history_final
INTO LOCAL OUTFILE  
'/mnt/volume_nyc3_01/var/lib/mysql-files/ny_history_final.csv' 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
;
