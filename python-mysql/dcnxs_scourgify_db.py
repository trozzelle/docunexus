
import dcnxs_scourgify
import mysql.connector
import json
from datetime import *
  
with open('../conf/config.json') as json_file:
    conf = json.load(json_file)
    db_user = "nxs_admin"
    db_db = "voter_files"
    db_host = conf["db"]["host"]
    db_port = conf["db"]["port"]
    db_pass = conf["db"]["passwords"][db_user]

def refresh_db(process_name,batch_size,run_seconds=30):
    start_time = datetime.now()
    stop_time = start_time + timedelta(seconds = run_seconds)

    con = mysql.connector.connect(
        host=db_host,
        user=db_user,
        password=db_pass,
        database=db_db
        )    

    more2process = True
    i = 1
    while more2process:
        if datetime.now() > stop_time:
            print(datetime.now())
            print(stop_time)
            print("RAN OUT OF TIME")
            con.close()
            return
        
        i = i + 1

        cur = con.cursor(dictionary=True)

        sql = """
            delete from dcnxs_ny.process_queue where connection_id = connection_id() and process_name = %(process_name)s
            """
        cur.execute(sql, {'process_name': process_name})
        
        sql = """
            insert into dcnxs_ny.process_queue (process_name,connection_id,nys_voter_id)
            select %(process_name)s,connection_id(), nys_voter_id
            from (
                select nys_voter_id 
                from dcnxs_ny.process_list 
                where process_name = %(process_name)s
                    and process_complete = 0
                limit %(batch_size)s
            ) x
            """
        cur.execute(sql, {'process_name': process_name,'batch_size': batch_size})
        
        con.commit()
        
        sql = """
            select count(*) as cnt
            from dcnxs_ny.process_queue 
            where connection_id = connection_id()
            and process_name = %(process_name)s
            """
        cur.execute(sql,{'process_name': process_name})

        cnt = cur.fetchone()["cnt"]
        if cnt == 0:
            print("STATUS:")
            print("COMPLETE!")
            con.close()
            return
        
        print('ITERATION: '+str(i))

        if process_name == 'refresh_residence_address':
            refresh_residence_address(con)
        elif process_name == 'refresh_mailing_address':
            refresh_mailing_address(con)
        elif process_name == 'refresh_previous_address':
            refresh_previous_address(con)
        
        sql = """
            UPDATE dcnxs_ny.process_list p, dcnxs_ny.process_queue q
            SET p.process_complete = 1
            WHERE q.connection_id = connection_id()
            and q.process_name = %(process_name)s
            and p.process_name = %(process_name)s
            and q.nys_voter_id = p.nys_voter_id
            """
        cur.execute(sql, {'process_name': process_name})
        
        con.commit()

    con.close()


def refresh_residence_address(con):

    cur = con.cursor(dictionary=True)

    sql = """
        select trim(d.nys_voter_id) as nys_voter_id, cast(trim(replace(replace(replace(replace(replace(replace(upper(
            concat(
                ifnull(d.residence_num,' '),' '
                ,ifnull(d.residence_halfnum,' '),' '
                ,ifnull(d.residence_aptnum,' '),' '
                ,ifnull(d.residence_pre_street_dir,' '),' '
                ,ifnull(d.residence_street_name,' '),' '
                ,ifnull(d.residence_post_street_dir,' '),' '
                ,ifnull(d.residence_city,' '),' NY '
                ,ifnull(d.residence_zip,' ')
                )
            ),'\\n',' '),'\\t',' '),'  ',' '),'  ',' '),'  ',' '),'  ',' '))
            as char) as residence_address
        from dcnxs_ny.process_queue q
        join dcnxs_ny.voter_data d on d.nys_voter_id = q.nys_voter_id
        where q.connection_id = connection_id()
        and q.process_name = 'refresh_residence_address'
        """
    cur.execute(sql)

    rows = cur.fetchall()

    for row in rows:

        clean_address = dcnxs_scourgify.scourgify_address({'address':row["residence_address"]})
        clean_address = json.loads(clean_address)

        sql = "replace into dcnxs_ny.voter_residence_address (nys_voter_id, residence_address) VALUES (%(nys_voter_id)s, %(residence_address)s)"
        cur.execute(sql, {'nys_voter_id':row["nys_voter_id"],'residence_address':clean_address["address"]})
        
        sql = "replace into dcnxs_ny.voter_city (nys_voter_id, residence_city) VALUES (%(nys_voter_id)s, %(residence_city)s)"
        cur.execute(sql, {'nys_voter_id':row["nys_voter_id"],'residence_city':clean_address["parsed_address"]["city"]})
        
        sql = "replace into dcnxs_ny.voter_street_name (nys_voter_id, residence_street_name) VALUES (%(nys_voter_id)s, %(residence_street_name)s)"
        cur.execute(sql, {'nys_voter_id':row["nys_voter_id"],'residence_street_name':clean_address["parsed_address"]["residence_street_name"]})

        #print(clean_address["parsed_address"])

def refresh_mailing_address(con):

    cur = con.cursor(dictionary=True)

    sql = """
        select trim(d.nys_voter_id) as nys_voter_id, cast(trim(replace(replace(replace(replace(replace(replace(upper(
            concat(
                ifnull(d.mailing_address_1,' '),' '
                ,ifnull(d.mailing_address_2,' '),' '
                ,ifnull(d.mailing_address_3,' '),' '
                ,ifnull(d.mailing_address_4,' ')
                )
            ),'\\n',' '),'\\t',' '),'  ',' '),'  ',' '),'  ',' '),'  ',' '))
            as char) as mailing_address
        from dcnxs_ny.process_queue q
        join dcnxs_ny.voter_data d on d.nys_voter_id = q.nys_voter_id
        where q.connection_id = connection_id()
        and q.process_name = 'refresh_mailing_address'
        """
    cur.execute(sql)

    rows = cur.fetchall()

    for row in rows:

        clean_address = dcnxs_scourgify.scourgify_address({'address':row["mailing_address"]})
        clean_address = json.loads(clean_address)

        sql = "replace into dcnxs_ny.voter_mailing_address (nys_voter_id, mailing_address) VALUES (%(nys_voter_id)s, %(mailing_address)s)"
        cur.execute(sql, {'nys_voter_id':row["nys_voter_id"],'mailing_address':clean_address["address"]})
    
def refresh_previous_address(con):

    cur = con.cursor(dictionary=True)

    sql = """
        select trim(d.nys_voter_id) as nys_voter_id, cast(trim(replace(replace(replace(replace(replace(replace(upper(
            d.previous_address
            ),'\\n',' '),'\\t',' '),'  ',' '),'  ',' '),'  ',' '),'  ',' '))
            as char) as previous_address
        from dcnxs_ny.process_queue q
        join dcnxs_ny.voter_data d on d.nys_voter_id = q.nys_voter_id
        where q.connection_id = connection_id()
        and q.process_name = 'refresh_previous_address'
        """
    cur.execute(sql)

    rows = cur.fetchall()

    for row in rows:

        clean_address = dcnxs_scourgify.scourgify_address({'address':row["previous_address"]})
        clean_address = json.loads(clean_address)

        sql = "replace into dcnxs_ny.voter_previous_address (nys_voter_id, previous_address) VALUES (%(nys_voter_id)s, %(previous_address)s)"
        cur.execute(sql, {'nys_voter_id':row["nys_voter_id"],'previous_address':clean_address["address"]})