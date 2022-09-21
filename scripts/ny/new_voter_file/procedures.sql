CREATE TABLE if not exists dcnxs_ny.process_list (
  process_name varchar(100) NOT NULL,
  nys_voter_id varchar(50) NOT NULL,
  process_complete int DEFAULT 0 NOT NULL,
  PRIMARY KEY (process_name,nys_voter_id),
  INDEX idx_process_complete (process_complete)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE if not exists dcnxs_ny.process_queue (
  connection_id int NOT NULL,
  process_name varchar(100) NOT NULL,
  nys_voter_id varchar(50) NOT NULL,
  PRIMARY KEY (connection_id,process_name,nys_voter_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


################################################################################################

drop procedure if exists dcnxs_ny.reset_process_list_prc;

DELIMITER $$

create procedure dcnxs_ny.reset_process_list_prc(p_process_name varchar(100))
sp: begin

if p_process_name like '%2' then

replace into dcnxs_ny.process_list (process_name,nys_voter_id,process_complete)
select distinct p_process_name, nys_voter_id,0
from import_ny.voter
where nys_voter_id is not null;
    
select process_name,process_complete,round(count(*)/1000000,3) as million_rows 
from dcnxs_ny.process_list group by process_name, process_complete;

else

replace into dcnxs_ny.process_list (process_name,nys_voter_id,process_complete)
select p_process_name, nys_voter_id,0
from dcnxs_ny.voter_data;
    
select process_name,process_complete,round(count(*)/1000000,3) as million_rows 
from dcnxs_ny.process_list group by process_name, process_complete;

end if;

select 'COMPLETE!' as "STATUS:";    

end $$

DELIMITER ;

################################################################################################

drop procedure if exists dcnxs_ny.refresh_email_prc;

DELIMITER $$

create procedure dcnxs_ny.refresh_email_prc()
sp: begin

replace into dcnxs_ny.voter_email
select e.* 
from dcnxs_ny.process_queue q
join dcnxs_ny.voter_email_v e on e.nys_voter_id = q.nys_voter_id
where q.connection_id = connection_id()
and q.process_name = 'refresh_email'
;

end $$

DELIMITER ;

################################################################################################

drop procedure if exists dcnxs_ny.refresh_phone_prc;

DELIMITER $$

create procedure dcnxs_ny.refresh_phone_prc()
sp: begin

replace into dcnxs_ny.voter_phone
select e.* 
from dcnxs_ny.process_queue q
join dcnxs_ny.voter_phone_v e on e.nys_voter_id = q.nys_voter_id
where q.connection_id = connection_id()
and q.process_name = 'refresh_phone'
;

end $$

DELIMITER ;

################################################################################################

drop procedure if exists dcnxs_ny.refresh_zip5_prc;

DELIMITER $$

create procedure dcnxs_ny.refresh_zip5_prc()
sp: begin

replace into dcnxs_ny.voter_zip5
select e.* 
from dcnxs_ny.process_queue q
join dcnxs_ny.voter_zip5_v e on e.nys_voter_id = q.nys_voter_id
where q.connection_id = connection_id()
and q.process_name = 'refresh_zip5'
;

end $$

DELIMITER ;

################################################################################################

drop procedure if exists dcnxs_ny.refresh_first_name_prc;

DELIMITER $$

create procedure dcnxs_ny.refresh_first_name_prc()
sp: begin

replace into dcnxs_ny.voter_first_name
select e.* 
from dcnxs_ny.process_queue q
join dcnxs_ny.voter_first_name_v e on e.nys_voter_id = q.nys_voter_id
where q.connection_id = connection_id()
and q.process_name = 'refresh_first_name'
;

end $$

DELIMITER ;

################################################################################################

drop procedure if exists dcnxs_ny.refresh_last_name_prc;

DELIMITER $$

create procedure dcnxs_ny.refresh_last_name_prc()
sp: begin

replace into dcnxs_ny.voter_last_name
select e.* 
from dcnxs_ny.process_queue q
join dcnxs_ny.voter_last_name_v e on e.nys_voter_id = q.nys_voter_id
where q.connection_id = connection_id()
and q.process_name = 'refresh_last_name'
;

end $$

DELIMITER ;

################################################################################################

drop procedure if exists dcnxs_ny.refresh_full_name_prc;

DELIMITER $$

create procedure dcnxs_ny.refresh_full_name_prc()
sp: begin

replace into dcnxs_ny.voter_full_name
select e.* 
from dcnxs_ny.process_queue q
join dcnxs_ny.voter_full_name_v e on e.nys_voter_id = q.nys_voter_id
where q.connection_id = connection_id()
and q.process_name = 'refresh_full_name'
;

end $$

DELIMITER ;

################################################################################################

drop procedure if exists dcnxs_ny.refresh_history_prc;

DELIMITER $$

create procedure dcnxs_ny.refresh_history_prc()
sp: begin

replace into dcnxs_ny.voter_history
select x.nys_voter_id,jt.election_name
from (
    SELECT a.nys_voter_id,
    cast(CONCAT('["', REPLACE(REPLACE(trim(a.voter_history), '"', ''''), ';', '", "'), '"]') as JSON) voter_history
    from dcnxs_ny.process_queue q
    join dcnxs_ny.voter_data a on a.nys_voter_id = q.nys_voter_id
    where q.connection_id = connection_id()
    and q.process_name = 'refresh_history'
    limit 0, 99999999999999
) x, JSON_TABLE(x.voter_history,'$[*]' COLUMNS(election_name varchar(150) PATH "$")) AS jt
;

end $$

DELIMITER ;

################################################################################################

drop procedure if exists dcnxs_ny.refresh_history2_prc;

DELIMITER $$

create procedure dcnxs_ny.refresh_history2_prc()
sp: begin

replace into dcnxs_ny.voter_history
select x.nys_voter_id,jt.election_name
from (
    SELECT a.nys_voter_id,
    cast(CONCAT('["', REPLACE(REPLACE(trim(a.voter_history), '"', ''''), ';', '", "'), '"]') as JSON) voter_history
    from dcnxs_ny.process_queue q
    join import_ny.voter a on a.nys_voter_id = q.nys_voter_id
    where q.connection_id = connection_id()
    and q.process_name = 'refresh_history2'
    limit 0, 99999999999999
) x, JSON_TABLE(x.voter_history,'$[*]' COLUMNS(election_name varchar(150) PATH "$")) AS jt
;

end $$

DELIMITER ;

################################################################################################

drop procedure if exists dcnxs_ny.refresh_elections_prc;

DELIMITER $$

create procedure dcnxs_ny.refresh_elections_prc()
sp: begin

replace into dcnxs_ny.elections (election_name,voter_count)
select election_name,count(*)
from dcnxs_ny.voter_history
group by election_name
;
update dcnxs_ny.elections 
set election_year_4_string = null
where election_name > ' '
;
update dcnxs_ny.elections 
set election_year_2_string = null
where election_name > ' '
;
update dcnxs_ny.elections 
set election_year = null
where election_name > ' '
and election_year > year(now())
;
update dcnxs_ny.elections 
set election_year_4_string = NULLIF(SUBSTR(election_name, REGEXP_INSTR (election_name, '[0-9]{4}') , 4),'')
where election_year_4_string is null
and election_name > ' '
;
update dcnxs_ny.elections 
set election_year_2_string = NULLIF(SUBSTR(election_name, REGEXP_INSTR (election_name, '[0-9]{2}') , 2),'')
where election_year_2_string is null
and election_name > ' '
;
UPDATE dcnxs_ny.elections
set election_year = election_year_4_string
where election_year is null
and election_name > ''
;
UPDATE dcnxs_ny.elections
set election_year_2 = election_year_2_string
where election_year_2 is null
and election_name > ''
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
update dcnxs_ny.elections set is_primary = 1 where ifnull(is_primary,0) = 0
and INSTR(lcase(election_name), 'primary') > 0 and election_name > ''
;
update dcnxs_ny.elections set is_general = 1 where ifnull(is_general,0) = 0
and INSTR(lcase(election_name), 'general') > 0 and election_name > ''
;
update dcnxs_ny.elections set is_general = 1 where ifnull(is_general,0) = 0
and election_name like '20% GE'
;
update dcnxs_ny.elections set is_general = 1 where ifnull(is_general,0) = 0
and election_name like '19% GE'
;
update dcnxs_ny.elections set is_democratic = 1 where ifnull(is_democratic,0) = 0
and INSTR(lcase(election_name), 'democrat') > 0 and election_name > ''
;
update dcnxs_ny.elections set is_republican = 1 where ifnull(is_republican,0) = 0
and INSTR(lcase(election_name), 'republican') > 0 and election_name > ''
;
update dcnxs_ny.elections set is_conservative = 1 where ifnull(is_conservative,0) = 0
and INSTR(lcase(election_name), 'conservative') > 0 and election_name > ''
;
update dcnxs_ny.elections set is_presidential = 1 where ifnull(is_presidential,0) = 0
and INSTR(lcase(election_name), 'presidential') > 0 and election_name > ''
;
update dcnxs_ny.elections set is_federal = 1 where ifnull(is_federal,0) = 0
and INSTR(lcase(election_name), 'federal') > 0 and election_name > ''
;
update dcnxs_ny.elections 
set election_year = null
where election_name > ' '
and election_year > year(now())
;
select election_year, sum(voter_count) from dcnxs_ny.elections group by election_year order by 2 desc;

select 'COMPLETE!' as "STATUS:";    

end $$

DELIMITER ;

################################################################################################

drop procedure if exists dcnxs_ny.refresh_prc;

DELIMITER $$

create procedure dcnxs_ny.refresh_prc(p_process_name varchar(100),p_batch_size int,p_run_until datetime)
sp: begin

  declare v_count int;
  declare v_rows_affected int;
  declare v_iteration int;

  select 0 into v_iteration;


  if p_process_name = 'refresh_elections' then
      call dcnxs_ny.refresh_elections_prc;
      select 'COMPLETE!' as "STATUS:";
          LEAVE sp;
  end if;

  REPEAT
  
    IF p_run_until < now() THEN
		select 'RAN OUT OF TIME' as "STATUS:";
        LEAVE sp;
    END IF;
    
    set v_iteration = v_iteration + 1;
    
    delete from dcnxs_ny.process_queue 
    where connection_id = connection_id()
    and process_name = p_process_name;

    insert into dcnxs_ny.process_queue (process_name,connection_id,nys_voter_id)
    select p_process_name,connection_id(), nys_voter_id
    from (
        select nys_voter_id 
        from dcnxs_ny.process_list 
        where process_name = p_process_name
          and process_complete = 0
        limit p_batch_size
    ) x;
    
    select count(*) into v_count 
    from dcnxs_ny.process_queue 
    where connection_id = connection_id()
      and process_name = p_process_name;
    
    select v_iteration as "ITERATION:";
    
    IF v_count = 0 THEN
		select 'COMPLETE!' as "STATUS:";
        LEAVE sp;
    END IF;
    
    if p_process_name = 'refresh_history' then
        call dcnxs_ny.refresh_history_prc;
    elseif p_process_name = 'refresh_history2' then
        call dcnxs_ny.refresh_history2_prc;
    elseif p_process_name = 'refresh_email' then
        call dcnxs_ny.refresh_email_prc;
    elseif p_process_name = 'refresh_phone' then
        call dcnxs_ny.refresh_phone_prc;
    elseif p_process_name = 'refresh_zip5' then
        call dcnxs_ny.refresh_zip5_prc;
    elseif p_process_name = 'refresh_first_name' then
        call dcnxs_ny.refresh_first_name_prc;
    elseif p_process_name = 'refresh_last_name' then
        call dcnxs_ny.refresh_last_name_prc;
    elseif p_process_name = 'refresh_full_name' then
        call dcnxs_ny.refresh_full_name_prc;
    end if;

    UPDATE dcnxs_ny.process_list p, dcnxs_ny.process_queue q
    SET p.process_complete = 1
    WHERE q.connection_id = connection_id()
    and q.process_name = p_process_name 
    and p.process_name = p_process_name
    and q.nys_voter_id = p.nys_voter_id
    ;
    
    delete from dcnxs_ny.process_queue 
    where connection_id = connection_id()
    and process_name = p_process_name;

	UNTIL p_run_until < now() 
    
  END REPEAT;
  
end $$

DELIMITER ;




