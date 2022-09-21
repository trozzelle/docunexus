drop procedure if exists import_ny.voter_refresh_history;

DELIMITER $$

create procedure import_ny.voter_refresh_history(p_batch_size int,p_run_until datetime)
sp: begin

  declare v_connection_id int;
  declare v_count int;
  declare v_rows_affected int;
  declare v_iteration int;

  select connection_id() into v_connection_id;
  select 0 into v_iteration;

  REPEAT
    set v_iteration = v_iteration + 1;
    
    delete from import_ny.voter_queue where connection_id = v_connection_id;

    insert into import_ny.voter_queue (connection_id,nys_voter_id)
    select v_connection_id, nys_voter_id
    from (
        select distinct nys_voter_id 
        from import_ny.voter_nys_voter_id_distinct where processed_history = 0
        limit p_batch_size
    ) x;
    
    select count(*) into v_count from import_ny.voter_queue where connection_id = v_connection_id;
    
    select v_iteration as "ITERATION:";
    
    IF v_count = 0 THEN
		select 'COMPLETE!' as "STATUS:";
        LEAVE sp;
    END IF;

    replace into dcnxs_ny.voter_history
    select x.nys_voter_id,jt.election_name
    from (
        SELECT a.nys_voter_id,
        cast(CONCAT('["', REPLACE(REPLACE(trim(a.voter_history), '"', ''''), ';', '", "'), '"]') as JSON) voter_history
        from import_ny.voter_queue q
        join import_ny.voter a on a.nys_voter_id = q.nys_voter_id
        where q.connection_id = v_connection_id
        and trim(a.voter_history) > ' '
        limit 0, 99999999999999
    ) x, JSON_TABLE(x.voter_history,'$[*]' COLUMNS(election_name varchar(150) PATH "$")) AS jt
    ;

	UPDATE import_ny.voter_nys_voter_id_distinct d, import_ny.voter_queue q
	SET d.processed_history = 1
	WHERE q.connection_id = v_connection_id
	and q.nys_voter_id = d.nys_voter_id 
    and d.etl_load_id > 0
	;

    delete from import_ny.voter_queue where connection_id = v_connection_id;

	UNTIL p_run_until < now() 
    
  END REPEAT;
  
end $$

DELIMITER ;

call import_ny.voter_refresh_history(30000,now() + INTERVAL 14400 second);


