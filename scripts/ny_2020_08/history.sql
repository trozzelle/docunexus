drop table if exists ny_2020_08.history0;

CREATE TABLE ny_2020_08.history0 (etl_load_id int, election_name varchar(255));

ALTER TABLE ny_2020_08.history0
ADD PRIMARY KEY (etl_load_id,election_name);

drop procedure if exists ny_2020_08.history_prc;

DELIMITER $$

create procedure ny_2020_08.history_prc(p_max_array_size int,p_batch_size int,p_run_until datetime)
sp: begin

  declare v_rows_affected int;
  declare v_times_rows_affect_is_0 int;

  select 0 into v_times_rows_affect_is_0;

  REPEAT
  
	replace into ny_2020_08.history0
	SELECT c.etl_load_id,
	JSON_UNQUOTE(JSON_EXTRACT(c.voter_history , CONCAT('$[', a.int_key, ']'))) AS full_name
	from
	shrd.dim_int a
	JOIN (
	SELECT a.etl_load_id,
	cast(CONCAT('["', REPLACE(a.voter_history, ';', '", "'), '"]') as JSON) voter_history
	from ny_2020_08.voter_file a
	left join ny_2020_08.history0 b on b.etl_load_id = a.etl_load_id
	where trim(a.voter_history) > ' '
	and b.etl_load_id is null
	limit p_batch_size
	) c ON a.int_key < JSON_LENGTH(c.voter_history)
    where a.int_key between 0 and p_max_array_size
	;
    
  SELECT ROW_COUNT() into v_rows_affected ;
  IF v_rows_affected = 0 THEN
    select v_times_rows_affect_is_0 + 1 into v_times_rows_affect_is_0;
  END IF;
  # select v_rows_affected, v_times_rows_affect_is_0;
  IF v_times_rows_affect_is_0 > 10 THEN
    select v_rows_affected, v_times_rows_affect_is_0;
    LEAVE sp;
  END IF;

	UNTIL p_run_until < now() 
    
  END REPEAT;
  
  select v_rows_affected, v_times_rows_affect_is_0, p_run_until, now();
  
end $$

DELIMITER ;

call  ny_2020_08.history_prc(1000,10000,now() + INTERVAL 24 second); # -- change second to hour and repeat until completely processed

drop table if exists dcnxs_ny.voter_history;

create table dcnxs_ny.voter_history(
  nys_voter_id varchar(50),
  election_name varchar(100)
 )
;

-- select "nys_voter_id","election_name"
-- union
-- select
-- a.nys_voter_id, 
-- trim(replace(replace(replace(replace(replace(replace(upper(
-- b.election_name
-- ),'\n',' '),'\t',' '),'  ',' '),'  ',' '),'  ',' '),'  ',' '))
-- from ny_2020_08.voter_file a
-- join ny_2020_08.history0 b on b.etl_load_id = a.etl_load_id
-- INTO OUTFILE  
-- '/mnt/volume_nyc3_01/var/lib/mysql-files/ny_history.tab' 
-- FIELDS TERMINATED BY '\t'
-- LINES TERMINATED BY '\n'
-- ;

-- LOAD DATA LOCAL INFILE '/mnt/volume_nyc3_01/var/lib/mysql-files/ny_history.tab'  IGNORE
-- INTO TABLE dcnxs_ny.voter_history
-- FIELDS TERMINATED BY '\t'
-- LINES TERMINATED BY '\n'
-- IGNORE 1 ROWS;
-- ;


SET autocommit=0; 
SET unique_checks=0; 
SET foreign_key_checks=0;
insert into dcnxs_ny.voter_history
select
a.nys_voter_id, 
trim(replace(replace(replace(replace(replace(replace(upper(
b.election_name
),'\n',' '),'\t',' '),'  ',' '),'  ',' '),'  ',' '),'  ',' '))
from ny_2020_08.voter_file a
join ny_2020_08.history0 b on b.etl_load_id = a.etl_load_id
limit 0
    , 10000000
;
commit;
insert into dcnxs_ny.voter_history
select
a.nys_voter_id, 
trim(replace(replace(replace(replace(replace(replace(upper(
b.election_name
),'\n',' '),'\t',' '),'  ',' '),'  ',' '),'  ',' '),'  ',' '))
from ny_2020_08.voter_file a
join ny_2020_08.history0 b on b.etl_load_id = a.etl_load_id
limit  9999999
    , 10000000
;
commit;
insert into dcnxs_ny.voter_history
select
a.nys_voter_id, 
trim(replace(replace(replace(replace(replace(replace(upper(
b.election_name
),'\n',' '),'\t',' '),'  ',' '),'  ',' '),'  ',' '),'  ',' '))
from ny_2020_08.voter_file a
join ny_2020_08.history0 b on b.etl_load_id = a.etl_load_id
limit 19999999
    , 10000000
;
commit;
insert into dcnxs_ny.voter_history
select
a.nys_voter_id, 
trim(replace(replace(replace(replace(replace(replace(upper(
b.election_name
),'\n',' '),'\t',' '),'  ',' '),'  ',' '),'  ',' '),'  ',' '))
from ny_2020_08.voter_file a
join ny_2020_08.history0 b on b.etl_load_id = a.etl_load_id
limit 29999999
    , 10000000
;
commit;
insert into dcnxs_ny.voter_history
select
a.nys_voter_id, 
trim(replace(replace(replace(replace(replace(replace(upper(
b.election_name
),'\n',' '),'\t',' '),'  ',' '),'  ',' '),'  ',' '),'  ',' '))
from ny_2020_08.voter_file a
join ny_2020_08.history0 b on b.etl_load_id = a.etl_load_id
limit 39999999
    , 10000000
;
commit;
insert into dcnxs_ny.voter_history
select
a.nys_voter_id, 
trim(replace(replace(replace(replace(replace(replace(upper(
b.election_name
),'\n',' '),'\t',' '),'  ',' '),'  ',' '),'  ',' '),'  ',' '))
from ny_2020_08.voter_file a
join ny_2020_08.history0 b on b.etl_load_id = a.etl_load_id
limit 49999999
    , 10000000
;
commit;
insert into dcnxs_ny.voter_history
select
a.nys_voter_id, 
trim(replace(replace(replace(replace(replace(replace(upper(
b.election_name
),'\n',' '),'\t',' '),'  ',' '),'  ',' '),'  ',' '),'  ',' '))
from ny_2020_08.voter_file a
join ny_2020_08.history0 b on b.etl_load_id = a.etl_load_id
limit 59999999
    , 10000000
;
commit;
insert into dcnxs_ny.voter_history
select
a.nys_voter_id, 
trim(replace(replace(replace(replace(replace(replace(upper(
b.election_name
),'\n',' '),'\t',' '),'  ',' '),'  ',' '),'  ',' '),'  ',' '))
from ny_2020_08.voter_file a
join ny_2020_08.history0 b on b.etl_load_id = a.etl_load_id
limit 69999999
    , 10000000
;
commit;
insert into dcnxs_ny.voter_history
select
a.nys_voter_id, 
trim(replace(replace(replace(replace(replace(replace(upper(
b.election_name
),'\n',' '),'\t',' '),'  ',' '),'  ',' '),'  ',' '),'  ',' '))
from ny_2020_08.voter_file a
join ny_2020_08.history0 b on b.etl_load_id = a.etl_load_id
limit 79999999
    , 10000000
;
commit;
insert into dcnxs_ny.voter_history
select
a.nys_voter_id, 
trim(replace(replace(replace(replace(replace(replace(upper(
b.election_name
),'\n',' '),'\t',' '),'  ',' '),'  ',' '),'  ',' '),'  ',' '))
from ny_2020_08.voter_file a
join ny_2020_08.history0 b on b.etl_load_id = a.etl_load_id
limit 89999999
    , 10000000
;
commit;
insert into dcnxs_ny.voter_history
select
a.nys_voter_id, 
trim(replace(replace(replace(replace(replace(replace(upper(
b.election_name
),'\n',' '),'\t',' '),'  ',' '),'  ',' '),'  ',' '),'  ',' '))
from ny_2020_08.voter_file a
join ny_2020_08.history0 b on b.etl_load_id = a.etl_load_id
limit 99999999
    , 10000000
;
commit;
SET autocommit=1; 
SET unique_checks=1; 
SET foreign_key_checks=1;

ALTER TABLE dcnxs_ny.voter_history 
  ADD PRIMARY KEY (nys_voter_id,election_name)
;  

drop table if exists dcnxs_ny.elections;

create table dcnxs_ny.elections as 
select h.*
, cast(null as unsigned) as election_year
, cast(null as unsigned) as election_year_2
, IF(INSTR ( h.election_name, 'primary') > 0,1,0) as is_primary
, IF(INSTR ( h.election_name, 'general') > 0,1,0) as is_general
, IF(INSTR ( h.election_name, 'special') > 0,1,0) as is_special
, IF(INSTR ( h.election_name, 'democrat') > 0,1,0) as is_democratic
, IF(INSTR ( h.election_name, 'republican') > 0,1,0) as is_republican
, IF(INSTR ( h.election_name, 'conservative') > 0,1,0) as is_conservative
, IF(INSTR ( h.election_name, 'presidential') > 0,1,0) as is_presidential
, IF(INSTR ( h.election_name, 'federal') > 0,1,0) as is_federal
, NULLIF(SUBSTR(  h.election_name, REGEXP_INSTR ( h.election_name, '[0-9]{4}') , 4),'') as election_year_4_string
, NULLIF(SUBSTR(  h.election_name, REGEXP_INSTR ( h.election_name, '[0-9]{2}') , 2),'') as election_year_2_string
from (
  select distinct election_name
  from dcnxs_ny.voter_history
) h  
; 

ALTER TABLE dcnxs_ny.elections 
  ADD PRIMARY KEY (election_name),
  ADD INDEX idx_election_year (election_year)
;  

UPDATE dcnxs_ny.elections
set election_year_2_string = null
where election_year_4_string > ''
and election_name > ''
;
UPDATE dcnxs_ny.elections
set election_year = election_year_4_string,election_year_2 = election_year_2_string
where election_name > ''
;
UPDATE dcnxs_ny.elections
set election_year = 2000 + election_year_2
where election_year is null
and election_year_2 is not null
and election_year_2 between 0 and 70
;
UPDATE dcnxs_ny.elections
set election_year = 1900 + election_year_2
where election_year is null
and election_year_2 > 70
;
