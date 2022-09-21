
drop table if exists import_ny.voter_count_by_vid;

create table import_ny.voter_count_by_vid as
select nys_voter_id, count(nys_voter_id) as cnt
from import_ny.voter
where nys_voter_id like 'NY%'
group by nys_voter_id;

ALTER TABLE import_ny.voter_count_by_vid 
ADD PRIMARY KEY (nys_voter_id),
ADD INDEX idx_cnt (cnt);

drop table if exists import_ny.voter_only_1_vid;

create table import_ny.voter_only_1_vid as
select a.etl_load_id, a.nys_voter_id
from import_ny.voter a
join import_ny.voter_count_by_vid b on b.nys_voter_id = a.nys_voter_id
where b.cnt = 1;

ALTER TABLE import_ny.voter_only_1_vid 
ADD PRIMARY KEY (etl_load_id),
ADD INDEX idx_nys_voter_id (nys_voter_id);

drop table if exists import_ny.voter_more_than_1_vid;

create table import_ny.voter_more_than_1_vid as
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
from import_ny.voter ny
join import_ny.voter_count_by_vid b on b.nys_voter_id = ny.nys_voter_id
where ny.nys_voter_id like 'NY%'
and b.cnt > 1;

ALTER TABLE import_ny.voter_more_than_1_vid 
ADD PRIMARY KEY (etl_load_id),
ADD INDEX idx_nys_voter_id (nys_voter_id),
ADD INDEX idx_xsequence (xsequence);

drop table if exists import_ny.voter_nys_voter_id_distinct;

create table import_ny.voter_nys_voter_id_distinct as
select nys_voter_id, max(etl_load_id) as etl_load_id
, 0 as processed_data
, 0 as processed_history
, 0 as processed_match_records
from (
  select nys_voter_id, etl_load_id
  from import_ny.voter_only_1_vid
  union
  select nys_voter_id, etl_load_id
  from import_ny.voter_more_than_1_vid
  where xsequence = 1
) x
group by nys_voter_id
;

ALTER TABLE import_ny.voter_nys_voter_id_distinct 
ADD PRIMARY KEY (etl_load_id),
ADD INDEX idx_nys_voter_id (nys_voter_id),
ADD INDEX idx_processed_data (processed_data),
ADD INDEX idx_processed_history (processed_history),
ADD INDEX idx_processed_match_records (processed_match_records);
