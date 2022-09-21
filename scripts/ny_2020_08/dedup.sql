ALTER TABLE ny_2020_08.voter_file
ADD COLUMN etl_load_id INT NOT NULL AUTO_INCREMENT,
ADD INDEX idx_nys_voter_id (nys_voter_id),
ADD INDEX idx_voter_status (voter_status),
ADD INDEX idx_purge_date (purge_date),
ADD INDEX idx_inactive_date (inactive_date),
ADD INDEX idx_last_voted_date (last_voted_date),
ADD PRIMARY KEY (etl_load_id);

drop table if exists ny_2020_08.count_by_vid;

create table ny_2020_08.count_by_vid as
select nys_voter_id, count(nys_voter_id) as cnt
from ny_2020_08.voter_file
where nys_voter_id like 'NY%'
group by nys_voter_id;

ALTER TABLE ny_2020_08.count_by_vid 
ADD PRIMARY KEY (nys_voter_id),
ADD INDEX idx_cnt (cnt);

drop table if exists ny_2020_08.only_1_vid;

create table ny_2020_08.only_1_vid as
select a.etl_load_id, b.cnt, a.nys_voter_id
from ny_2020_08.voter_file a
join ny_2020_08.count_by_vid b on b.nys_voter_id = a.nys_voter_id
where b.cnt = 1;

ALTER TABLE ny_2020_08.only_1_vid 
ADD PRIMARY KEY (etl_load_id),
ADD INDEX idx_nys_voter_id (nys_voter_id);

drop table if exists ny_2020_08.more_than_1_vid;

create table ny_2020_08.more_than_1_vid as
select ny.etl_load_id, ny.nys_voter_id
, rank()over(
  partition by ny.nys_voter_id
  order by
    case
      when(trim(ny.voter_status)= 'ACTIVE')  then '001'
      when(trim(ny.voter_status)= 'PREREG')  then '002'
      when(trim(ny.voter_status)= 'INACTIVE')then '003'
      when(trim(ny.voter_status)= 'PURGED')  then '004'
      else '999' end
      , ifnull(replace(trim(ny.purge_date), '', null), '99999999')desc
      , ifnull(replace(trim(ny.inactive_date), '', null), '99999999')desc
      , ifnull(replace(trim(ny.last_voted_date), '', null), '00000000')desc
)as xsequence
from ny_2020_08.voter_file ny
join ny_2020_08.count_by_vid b on b.nys_voter_id = ny.nys_voter_id
where ny.nys_voter_id like 'NY%'
and b.cnt > 1;

ALTER TABLE ny_2020_08.more_than_1_vid 
ADD PRIMARY KEY (etl_load_id),
ADD INDEX idx_nys_voter_id (nys_voter_id),
ADD INDEX idx_xsequence (xsequence);

drop table if exists ny_2020_08.nys_voter_id_distinct;

create table ny_2020_08.nys_voter_id_distinct as
select nys_voter_id, max(etl_load_id) as etl_load_id
from (
  select nys_voter_id, etl_load_id
  from ny_2020_08.only_1_vid
  union
  select nys_voter_id, etl_load_id
  from ny_2020_08.more_than_1_vid
  where xsequence = 1
) x
group by nys_voter_id
;

ALTER TABLE ny_2020_08.nys_voter_id_distinct 
ADD PRIMARY KEY (etl_load_id);

drop table if exists dcnxs_ny.voter_data;

create table dcnxs_ny.voter_data as
select 
 trim(a.last_name) as last_name,
 trim(a.first_name) as first_name,
 trim(a.middle_name) as middle_name,
 trim(a.name_suffix) as name_suffix,
 trim(a.residence_num) as residence_num,
 trim(a.residence_halfnum) as residence_halfnum,
 trim(a.residence_aptnum) as residence_aptnum,
 trim(a.residence_pre_street_dir) as residence_pre_street_dir,
 trim(a.residence_street_name) as residence_street_name,
 trim(a.residence_post_street_dir) as residence_post_street_dir,
 trim(a.residence_city) as residence_city,
 trim(a.residence_zip) as residence_zip,
 trim(a.residence_zip_4) as residence_zip_4,
 trim(a.mailing_address_1) as mailing_address_1,
 trim(a.mailing_address_2) as mailing_address_2,
 trim(a.mailing_address_3) as mailing_address_3,
 trim(a.mailing_address_4) as mailing_address_4,
 trim(a.date_of_birth) as date_of_birth,
 trim(a.gender) as gender,
 trim(a.enrollment) as enrollment,
 trim(a.other_party) as other_party,
 trim(a.county_code) as county_code,
 trim(a.election_district) as election_district,
 trim(a.legislative_district) as legislative_district,
 trim(a.town_city) as town_city,
 trim(a.ward) as ward,
 trim(a.congressional_district) as congressional_district,
 trim(a.senate_district) as senate_district,
 trim(a.assembly_district) as assembly_district,
 trim(a.last_voted_date) as last_voted_date,
 trim(a.last_voted_year) as last_voted_year,
 trim(a.last_voted_county) as last_voted_county,
 trim(a.previous_address) as previous_address,
 trim(a.last_registered_name) as last_registered_name,
 trim(a.county_voter_reg_num) as county_voter_reg_num,
 trim(a.application_date) as application_date,
 trim(a.application_source) as application_source,
 trim(a.id_required) as id_required,
 trim(a.id_required_met) as id_required_met,
 trim(a.voter_status) as voter_status,
 trim(a.voter_status_reason) as voter_status_reason,
 trim(a.inactive_date) as inactive_date,
 trim(a.purge_date) as purge_date,
 trim(a.nys_voter_id) as nys_voter_id,
 trim(a.telephone) as telephone,
 trim(a.email) as email
from ny_2020_08.voter_file a
join ny_2020_08.nys_voter_id_distinct d on d.etl_load_id = a.etl_load_id 
;

ALTER TABLE dcnxs_ny.voter_data
  ADD PRIMARY KEY (nys_voter_id),
  ADD INDEX idx_date_of_birth (date_of_birth),
  ADD INDEX idx_gender (gender),
  ADD INDEX idx_enrollment (enrollment),
  ADD INDEX idx_county_code (county_code),
  ADD INDEX idx_election_district (election_district),
  ADD INDEX idx_legislative_district (legislative_district),
  ADD INDEX idx_town_city (town_city),
  ADD INDEX idx_ward (ward),
  ADD INDEX idx_congressional_district (congressional_district),
  ADD INDEX idx_senate_district (senate_district),
  ADD INDEX idx_assembly_district (assembly_district),
  ADD INDEX idx_last_voted_date (last_voted_date),
  ADD INDEX idx_last_voted_year (last_voted_year),
  ADD INDEX idx_last_registered_name (last_registered_name),
  ADD INDEX idx_voter_status (voter_status)
  ;
  