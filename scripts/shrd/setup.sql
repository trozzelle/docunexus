create database shrd;
drop table if exists shrd.tmp_dim_int1;
create table shrd.tmp_dim_int1  
SELECT @row := @row + 1 as int_key from (select 0 union all select 1 union all select 3 union all select 4 union all select 5 union all select 6 union all select 6 union all select 7 union all select 8 union all select 9) t7,
(select 0 union all select 1 union all select 3 union all select 4 union all select 5 union all select 6 union all select 6 union all select 7 union all select 8 union all select 9) t6,
(select 0 union all select 1 union all select 3 union all select 4 union all select 5 union all select 6 union all select 6 union all select 7 union all select 8 union all select 9) t5,
(select 0 union all select 1 union all select 3 union all select 4 union all select 5 union all select 6 union all select 6 union all select 7 union all select 8 union all select 9) t4, 
(select 0 union all select 1 union all select 3 union all select 4 union all select 5 union all select 6 union all select 6 union all select 7 union all select 8 union all select 9) t3, 
(select 0 union all select 1 union all select 3 union all select 4 union all select 5 union all select 6 union all select 6 union all select 7 union all select 8 union all select 9) t2,  
(SELECT @row:=0) t;

drop table if exists shrd.tmp_dim_int2;
create table shrd.tmp_dim_int2    
select 0 - int_key as int_key from shrd.tmp_dim_int1
union all
SELECT 0 as iteration_number;

drop table if exists shrd.dim_int;
create table shrd.dim_int 
(primary key (int_key))
select int_key from shrd.tmp_dim_int2
union all
select int_key from shrd.tmp_dim_int1;

drop table if exists shrd.tmp_dim_int1;
drop table if exists shrd.tmp_dim_int2;

drop table if exists shrd.dim_date;
create table shrd.dim_date  
(primary key (date_key)
,index month_key (month_key) using hash
,index quarter_key (quarter_key) using hash
,index year_key (year_key) using hash
,index last_week_date_key (last_week_date_key) using hash
,index next_week_date_key (next_week_date_key) using hash
,index last_month_date_key (last_month_date_key) using hash
,index next_month_date_key (next_month_date_key) using hash
,index day_of_month (day_of_month) using hash
)
select CAST(DATE_FORMAT(a.date_date ,'%Y%m%d') as unsigned) as date_key
, DAYOFWEEK(date_date)  as day_of_week
, DAYNAME(date_date)  as day_name_of_week
, DAYOFMONTH(date_date)  as day_of_month
, DAYOFYEAR(date_date)  as day_of_year
, CASE DAYNAME(date_date)
    WHEN 'Saturday' THEN 0
    WHEN 'Sunday' THEN 0
    ELSE 1
  END  as is_weekday
, WEEKOFYEAR(date_date) as week_of_year
, MONTHNAME(date_date)  as month_name
, MONTH(date_date)  as month_of_year
, if(MONTH(date_date) = MONTH(date_add(date_date, interval 1 day)),0,1)  as is_last_day_of_month
, QUARTER(date_date)  as calendar_quarter
, concat('Date(', year(a.date_date),', ', month(a.date_date) - 1,', ', day(a.date_date),')') as javascript_date
, CAST(DATE_FORMAT(date_add(date_date, interval -1 day) ,'%Y%m%d') as unsigned) yesterday_date_key
, CAST(DATE_FORMAT(date_add(date_date, interval 1 day) ,'%Y%m%d') as unsigned) tomorrow_date_key
, CAST(DATE_FORMAT(date_add(date_date, interval -1 week) ,'%Y%m%d') as unsigned) last_week_date_key
, CAST(DATE_FORMAT(date_add(date_date, interval 1 week) ,'%Y%m%d') as unsigned) next_week_date_key
, CAST(DATE_FORMAT(date_add(date_date, interval -1 month) ,'%Y%m%d') as unsigned) last_month_date_key
, CAST(DATE_FORMAT(date_add(date_date, interval 1 month) ,'%Y%m%d') as unsigned) next_month_date_key
, CAST(DATE_FORMAT(date_add(date_date, interval -3 month) ,'%Y%m%d') as unsigned) last_quarter_date_key
, CAST(DATE_FORMAT(date_add(date_date, interval 3 month) ,'%Y%m%d') as unsigned) next_quarter_date_key
, CAST(DATE_FORMAT(date_add(date_date, interval -1 year) ,'%Y%m%d') as unsigned) last_year_date_key
, CAST(DATE_FORMAT(date_add(date_date, interval 1 year) ,'%Y%m%d') as unsigned) next_year_date_key
, CAST(DATE_FORMAT(date_add(date_date, interval 4-DAYOFWEEK(date_date) day) ,'%Y%m%d') as unsigned) week_key
, CAST(CONCAT(CAST(YEAR(date_date) AS CHAR(4)),DATE_FORMAT(date_date,'%m'),'01') as unsigned)  as month_start_key
, CONCAT(CAST(YEAR(date_date) AS CHAR(4)),'w',right(concat('0',WEEKOFYEAR(date_date)),2)) as week_key2
, CAST(CONCAT(CAST(YEAR(date_date) AS CHAR(4)),DATE_FORMAT(date_date,'%m')) as unsigned) as month_key
, CAST(YEAR(date_date) * 10 + QUARTER(date_date) as unsigned) as quarter_key   
, YEAR(date_date)  as year_key  
from (
	select date_add(now(), interval int_key day) as date_date
	from shrd.dim_int
    where int_key between 0 - DATEDIFF(now(), "0001-01-01") and DATEDIFF("5999-12-31",now())
) a
;
CREATE TABLE shrd.api_get_position (
  id int NOT NULL AUTO_INCREMENT,
  source_name varchar(255) NOT NULL,
  target_schema varchar(255) NOT NULL,
  target_table varchar(255) NOT NULL,
  refresh_type varchar(255) NOT NULL,
  ts timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  json_position json DEFAULT NULL,
  PRIMARY KEY (id)
) ;

create or replace view shrd.api_get_position_v as
select a.* 
from shrd.api_get_position a
where a.id = (select max(b.id) 
				from shrd.api_get_position b 
                where b.source_name = a.source_name
                and b.target_schema = a.target_schema
                and b.target_table = a.target_table
                and b.refresh_type = a.refresh_type)
;