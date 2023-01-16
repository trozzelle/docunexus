import mysql.connector
import json
import math
from datetime import *
from sodapy import Socrata
import urllib
import ssl
import pathlib
import os
import pandas as pd
import psycopg2
# from sqlalchemy import create_engine
import processing_helper

working_dir = os.getcwd()
    # os.path.dirname(__file__)

source_name = "data.ny.gov"
target_user = "tr"
target_schema = "import_ny"

## Array of dataset ids from data.ny.gov

# https://data.ny.gov/browse?Dataset-Information_Agency=Elections%2C+Board+of&category=Government+%26+Finance
table_to_resource = {}
# Campaign Finance Disclosure Reports Data: Beginning 1999 ... >13M records
table_to_resource["cf_disclosure_report"] = 'e9ss-239a'
# Campaign Finance Filer Data: Beginning 1974 ... <50K records
table_to_resource["cf_filer"] = '7x2g-h32p'
# New York State ZIP Codes-County FIPS Cross-Reference ... <60K records
table_to_resource["zip_county_fips_xref"] = 'juva-r6g2'

## Model definitions for csvs as they come out of data.ny.gov

# list fields in order by position in CSV
csv_column = {}
csv_column["cf_disclosure_report"] = [
    'filer_id', 'filer_previous_id', 'cand_comm_name', 'election_year', 'election_type', 'county_desc',
    'filing_abbrev', 'filing_desc', 'r_amend', 'filing_cat_desc', 'filing_sched_abbrev', 'filing_sched_desc',
    'loan_lib_number', 'trans_number', 'trans_mapping', 'sched_date', 'org_date', 'cntrbr_type_desc',
    'cntrbn_type_desc', 'transfer_type_desc', 'receipt_type_desc', 'receipt_code_desc', 'purpose_code_desc',
    'r_subcontractor', 'flng_ent_name', 'flng_ent_first_name', 'flng_ent_middle_name', 'flng_ent_last_name',
    'flng_ent_add1', 'flng_ent_city', 'flng_ent_state', 'flng_ent_zip', 'flng_ent_country',
    'payment_type_desc', 'pay_number', 'owed_amt', 'org_amt', 'loan_other_desc', 'trans_explntn',
    'r_itemized', 'r_liability', 'election_year_r', 'office_desc', 'district', 'dist_off_cand_bal_prop'
]
csv_column["cf_filer"] = [
    'filer_id', 'filer_name', 'compliance_type_desc', 'filer_type_desc', 'filer_status',
    'committee_type_desc', 'office_desc', 'district', 'county_desc', 'municipality_subdivision_desc',
    'treasurer_first_name', 'treasurer_middle_name', 'treasurer_last_name',
    'address', 'city', 'state', 'zipcode'
]
csv_column["zip_county_fips_xref"] = [
    'county_name', 'state_fips', 'county_code', 'county_fips', 'zip_code', 'file_date'
]
csv_column["voter"] = [
    'last_name', 'first_name', 'middle_name', 'name_suffix', 'residence_num', 'residence_halfnum',
    'residence_aptnum', 'residence_pre_street_dir', 'residence_street_name', 'residence_post_street_dir',
    'residence_city', 'residence_zip', 'residence_zip_4', 'mailing_address_1', 'mailing_address_2',
    'mailing_address_3', 'mailing_address_4', 'date_of_birth', 'gender', 'enrollment', 'other_party',
    'county_code', 'election_district', 'legislative_district', 'town_city', 'ward', 'congressional_district',
    'senate_district', 'assembly_district', 'last_voted_date', 'last_voted_year', 'last_voted_county',
    'previous_address', 'last_registered_name', 'county_voter_reg_num', 'application_date',
    'application_source', 'id_required', 'id_required_met', 'voter_status', 'voter_status_reason',
    'inactive_date', 'purge_date', 'nys_voter_id', 'voter_history', 'telephone', 'email'
]

## Table definitions for how we'll store them in the DB
## Right now, only voter file. This would be a good place to
## clean up column names.

csv_create_columns = {}
# override voter because voter_history is large and needs to be TEXT
csv_create_columns["voter"] = """
last_name varchar(255),
first_name varchar(255),
middle_name varchar(255),
name_suffix varchar(255),
residence_num varchar(255),
residence_halfnum varchar(255),
residence_aptnum varchar(255),
residence_pre_street_dir varchar(255),
residence_street_name varchar(255),
residence_post_street_dir varchar(255),
residence_city varchar(255),
residence_zip varchar(255),
residence_zip_4 varchar(255),
mailing_address_1 varchar(255),
mailing_address_2 varchar(255),
mailing_address_3 varchar(255),
mailing_address_4 varchar(255),
date_of_birth varchar(255),
gender varchar(255),
enrollment varchar(255),
other_party varchar(255),
county_code varchar(255),
election_district varchar(255),
legislative_district varchar(255),
town_city varchar(255),
ward varchar(255),
congressional_district varchar(255),
senate_district varchar(255),
assembly_district varchar(255),
last_voted_date varchar(255),
last_voted_year varchar(255),
last_voted_county varchar(255),
previous_address varchar(255),
last_registered_name varchar(255),
county_voter_reg_num varchar(255),
application_date varchar(255),
application_source varchar(255),
id_required varchar(255),
id_required_met varchar(255),
voter_status varchar(255),
voter_status_reason varchar(255),
inactive_date varchar(255),
purge_date varchar(255),
nys_voter_id varchar(255),
voter_history text,
telephone varchar(255),
email varchar(255)
"""

print("Starting script...")

## Iterates over the model definitions (cf_disclosure_report, cf_filer, voter) and
# for each iterates over each column, building a table definition SQL string
# Assumes dtype is varchar(255) if not specified

csv_dtype = {}
csv_column_list_string = {}
csv_column_list_string_sub = {}
csv_column_list_string_sub2 = {}

for key, value in csv_column.items():
    if key not in csv_create_columns:
        csv_create_columns[key] = " varchar(255),\n".join(value) + ' varchar(255)'
    csv_column_list_string[key] = ','.join(value)
    csv_column_list_string_sub[key] = []
    csv_column_list_string_sub2[key] = []
    csv_dtype[key] = {}
    for i in value:
        csv_column_list_string_sub[key].append('%(' + i + ')s')  # named substitution
        csv_column_list_string_sub2[key].append('%s')  # generic substitution
        csv_dtype[key][i] = "string"
    csv_column_list_string_sub[key] = ','.join(csv_column_list_string_sub[key])
    csv_column_list_string_sub2[key] = ','.join(csv_column_list_string_sub2[key])

print("Table DDL created.")

## Load config

with open('../conf/config.json') as json_file:
    conf = json.load(json_file)
    target_host = conf["db"]["host"]
    target_port = conf["db"]["port"]
    target_pass = conf["db"]["passwords"][target_user]
    api_user = conf["api"][source_name]["id"]
    api_pass = conf["api"][source_name]["secret"]
    api_token = conf["api"][source_name]["token"]
    mysql_files_location = str(os.getenv('MYSQL_FILES_LOCATION'))

ssl._create_default_https_context = ssl._create_unverified_context

print("DB config loaded.")


## Pulls csvs from data.ny.gov
def download_target_csv(target_table):
    print(f"Attempting to download {target_table}")
    resource_csv_url = "https://data.ny.gov/api/views/%s/rows.csv?accessType=DOWNLOAD&sorting=true" \
                       % (table_to_resource[target_table])
    file = target_schema + "/" + target_table + ".csv"
    pathlib.Path(os.path.split(file)[0]).mkdir(parents=True, exist_ok=True)
    urllib.request.urlretrieve(resource_csv_url, file)
    print(f"Download succeeded. Downloaded to {file}")


## Creates SQL statements and loads csv into DB
def load_target_csv(target_table):
    print(f"Starting load of {target_table}")
    # infile = target_schema + "/" + target_table + ".csv"

    infile = os.getcwd() + '\\' + target_schema + '\\'+ target_table + "-TEST_DATA.csv"
    pathlib_infile = pathlib.Path(infile)
    csv_downloaded_at = datetime.fromtimestamp(pathlib_infile.stat().st_ctime).strftime("%Y-%m-%d %H:%M:%S")

    (f"Building SQL load statement for buffer table.")
    create_columns = csv_create_columns[target_table]
    insert_columns = csv_column_list_string[target_table]
    insert_sub = csv_column_list_string_sub2[target_table]
    buffer_table = target_schema + "." + target_table + "_csv"

#       Changes from original mysql statement
#        csv_id int not null auto_increment,
#       csv_downloaded_at datetime not null default '%(csv_downloaded_at)s',


    create_buffer_sql = """
    create table if not exists %(buffer_table)s (
        csv_id serial,
        csv_downloaded_at timestamp default '%(csv_downloaded_at)s',
        %(create_columns)s,
    primary key (csv_id)
    )
    """ % {"buffer_table": buffer_table,
           "create_columns": create_columns,
           "csv_downloaded_at": csv_downloaded_at}

    print("""BUFFER CREATE:
    """ + create_buffer_sql)

    insert_buffer_sql = """
    INSERT INTO %(buffer_table)s (%(insert_columns)s) 
    VALUES (%(insert_sub)s)
    """ % {"buffer_table": buffer_table,
           "insert_columns": insert_columns,
           "insert_sub": insert_sub}
    print("""BUFFER INSERT:
    """ + insert_buffer_sql)

    processing_helper.print_with_time(buffer_table + ' load starting')

    # con = mysql.connector.connect(host=target_host, port=target_port, user=target_user, password=target_pass,
    #                               database=target_schema)

    con = psycopg2.connect(host=target_host, port=target_port, user=target_user, password=target_pass, database=target_schema)

    # cur = con.cursor(dictionary=True, buffered=True)
    cur = con.cursor()
    cur.execute("drop table if exists " + buffer_table)
    con.commit()
    cur.execute(create_buffer_sql)
    con.commit()
    chunksize = 100000
    # sql_engine = create_engine('mysql://'+target_user+':'+target_pass+'@'+target_host+':'+target_port+'/'+target_schema)
    for df in pd.read_csv(infile, chunksize=chunksize, names=csv_column[target_table], dtype=csv_dtype[key],
                          index_col=None, iterator=True, skiprows=1):
        df = df.where(pd.notnull(df), '')
        # df.to_sql(buffer_table, sql_engine, if_exists='append', index=False) # creates table even with append :(
        # manually insert since to_sql with append isn't working
        data = list(map(tuple, df.values.tolist()))
        cur.executemany(insert_buffer_sql, data)
        con.commit()
    processing_helper.print_with_time(buffer_table + ' loaded')

    con.close()


## Breaks up buffer table into hash, track, and change tables
## Creates two views

def process_target_table(target_table):
    print(f"Processing buffer table into final tables")
    create_columns = csv_create_columns[target_table]
    insert_columns = csv_column_list_string[target_table]
    buffer_table = target_schema + "." + target_table + "_csv"
    hash_table = target_schema + "." + target_table + "_hash"
    track_table = target_schema + "." + target_table + "_track"
    change_table = target_schema + "." + target_table + "_change"
    stat_view = target_schema + "." + target_table + "_stat"
    current_view = target_schema + "." + target_table + "_current"

    print(f"Building SQL statement")
    create_hash_sql = """
    create table if not exists %(hash_table)s (
        csv_id int not null,
        row_hash varchar(40) not null,
        csv_downloaded_at timestamp not null,
    primary key (csv_id)
    );
    drop index if exists %(target_table)s_hash_rowhash_idx;
    create index %(target_table)s_hash_rowhash_idx on %(hash_table)s(row_hash)
    """ % {"hash_table": hash_table, "target_table": target_table}
    print("""HASH CREATE:
    """ + create_hash_sql)

    create_track_sql = """
    create table if not exists %(track_table)s (
        row_hash varchar(40) not null,
        csv_downloaded_at timestamp not null,
    primary key (row_hash)
    );
    drop index if exists %(target_table)s_track_csv_downloaded_at_idx;
    create index %(target_table)s_track_csv_downloaded_at_idx on %(track_table)s(csv_downloaded_at)
    """ % {"track_table": track_table, "target_table": target_table}
    print("""TRACK CREATE:
    """ + create_track_sql)

    create_change_sql = """
    create table if not exists %(change_table)s (
        %(create_columns)s,
        row_hash varchar(40) not null,
        change_type varchar(1) not null,
        changed_at timestamp not null,
        related_changed_at timestamp,
        current_ind smallint not null default 1,
    primary key (row_hash,change_type,changed_at,current_ind))
    partition by hash(current_ind);
    create table %(change_table)s_0 partition of %(change_table)s for values (modulus 2, remainder 0);
    create table %(change_table)s_1 partition of %(change_table)s for values (modulus 2, remainder 1);
    drop index if exists %(target_table)s_change_related_changed_at_idx;
    create index %(target_table)s_change_related_changed_at_idx on %(change_table)s(related_changed_at)
    """ % {"change_table": change_table,
           "create_columns": create_columns,
           "target_table": target_table,}
    print("""CHANGE CREATE:
    """ + create_change_sql)

    insert_hash_sql = """
    INSERT INTO %(hash_table)s (csv_id,row_hash,csv_downloaded_at) 
    select csv_id, sha1(concat_ws(%(insert_columns)s)) as row_hash, csv_downloaded_at
    from %(buffer_table)s
    """ % {"hash_table": hash_table,
           "buffer_table": buffer_table,
           "insert_columns": insert_columns}
    print("""HASH INSERT:
    """ + insert_hash_sql)

    insert_track_sql = """
    INSERT INTO %(track_table)s (row_hash,csv_downloaded_at) 
    select distinct row_hash,csv_downloaded_at
    from %(hash_table)s
    on conflict do nothing
    """ % {"track_table": track_table,
           "hash_table": hash_table}
    print("""TRACK INSERT:
    """ + insert_track_sql)

    # Add created rows to change table from track table
    insert_change_sql = """
    insert into %(change_table)s 
       (%(insert_columns)s,
        row_hash,
        change_type,
        changed_at)
    with latest_loaded as (select csv_downloaded_at from %(hash_table)s limit 1)
    select distinct %(insert_columns)s,
           t.row_hash,
           'C' as change_type, 
           ll.csv_downloaded_at as changed_at
    from latest_loaded ll
    join %(track_table)s t on t.csv_downloaded_at = ll.csv_downloaded_at
    join %(hash_table)s h on h.row_hash = t.row_hash
    join %(buffer_table)s b on b.csv_id = h.csv_id
    on conflict do nothing
    """ % {"buffer_table": buffer_table,
           "track_table": track_table,
           "hash_table": hash_table,
           "change_table": change_table,
           "insert_columns": insert_columns}
    print("""CHANGE INSERT (new rows):
    """ + insert_change_sql)

    # Add deleted rows to change table from track table
    insert_change_sql2 = """
    insert into %(change_table)s 
       (%(insert_columns)s,
        row_hash,
        change_type,
        changed_at,
        current_ind,
        related_changed_at)
    select %(insert_columns)s,
           t.row_hash,
           'D' as change_type, 
           (select csv_downloaded_at from %(hash_table)s limit 1) as changed_at,
           0,
           c.changed_at
    from %(track_table)s t 
    join %(change_table)s c on c.row_hash = t.row_hash and c.changed_at = t.csv_downloaded_at and c.change_type = 'C' # and c.current_ind = 1
    left join %(hash_table)s h on h.row_hash = t.row_hash
    where h.row_hash is null  
    on conflict do nothing
    """ % {"track_table": track_table,
           "change_table": change_table,
           "hash_table": hash_table,
           "insert_columns": insert_columns}
    print("""CHANGE INSERT (deleted rows):
    """ + insert_change_sql2)

    # Remove deleted rows from track table
    delete_track_sql = """
    delete
    from %(track_table)s t
    using  %(hash_table)s h
    where t.row_hash <> ' '
    and h.row_hash is null 
    and t.row_hash = h.row_hash 
    """ % {"hash_table": hash_table,
           "track_table": track_table}
    print("""TRACK DELETE:
    """ + delete_track_sql)

    ## Preserved for reference until new code checks out
    # # Remove deleted rows from track table
    # delete_track_sql = """
    # delete t
    # from %(track_table)s t
    # left join %(hash_table)s h on h.row_hash = t.row_hash
    # where t.row_hash <> ' '
    # and h.row_hash is null
    # """ % {"hash_table": hash_table,
    #        "track_table": track_table}
    # print("""TRACK DELETE:
    # """ + delete_track_sql)

    # Update C rows
    update_change_sql = """
    update %(change_table)s c
    set related_changed_at = d.changed_at, current_ind = 0
    from %(change_table)s d
    where c.change_type = 'C' 
    and c.related_changed_at is null
    and d.change_type = 'D'
    and d.changed_at = (select csv_downloaded_at from %(hash_table)s limit 1)
    and d.row_hash = c.row_hash
    """ % {"hash_table": hash_table,
           "change_table": change_table}
    print("""CHANGE UPDATE:
    """ + update_change_sql)

    ## Preserved for reference until new code checks out
    # # Update C rows
    # update_change_sql = """
    #     update %(change_table)s c
    #     join %(change_table)s d on d.change_type = 'D'
    # 									and d.changed_at = (select csv_downloaded_at from %(hash_table)s limit 1)
    #                                     and d.row_hash = c.row_hash
    #     set c.related_changed_at = d.changed_at, c.current_ind = 0
    #     where c.change_type = 'C' and c.related_changed_at is null
    #     """ % {"hash_table": hash_table,
    #            "change_table": change_table}
    # print("""CHANGE UPDATE:
    #     """ + update_change_sql)

    stat_view_sql = """
    create or replace view %(stat_view)s as 
    SELECT 'csv' as count_type,count(*) as record_count FROM %(buffer_table)s
    union all
    SELECT 'hash',count(*) FROM %(hash_table)s
    union all
    SELECT 'track',count(*) FROM %(track_table)s
    union all
    SELECT 'change - current',count(*) FROM %(change_table)s where current_ind = 1
    union all
    SELECT 'change',count(*) FROM %(change_table)s
    union all
    SELECT 'change C',count(*) FROM %(change_table)s where change_type = 'C'
    union all
    SELECT 'change D',count(*) FROM %(change_table)s where change_type = 'D'
    union all
    SELECT (current_ind || ' ' || change_type || ' changed_at '|| changed_at || ' deleted ' || COALESCE(related_changed_at,'none')),count(*) 
    FROM %(change_table)s 
    group by current_ind, change_type, changed_at, related_changed_at
    """ % {"hash_table": hash_table,
           "buffer_table": buffer_table,
           "track_table": track_table,
           "change_table": change_table,
           "stat_view": stat_view}
    print("""STAT VIEW:
    """ + stat_view_sql)

    current_view_sql = """
    create or replace view %(current_view)s as 
    select %(insert_columns)s, row_hash
    from %(change_table)s
    where current_ind = 1
    """ % {"change_table": change_table,
           "current_view": current_view,
           "insert_columns": insert_columns}
    print("""CURRENT VIEW:
    """ + current_view_sql)

    processing_helper.print_with_time(target_table + ' processing started')

    con = mysql.connector.connect(host=target_host, port=target_port, user=target_user, password=target_pass,
                                  database=target_schema)
    cur = con.cursor(dictionary=True, buffered=True)

    cur.execute("drop table if exists " + hash_table)
    con.commit()
    cur.execute(create_hash_sql)
    con.commit()
    cur.execute(insert_hash_sql)
    con.commit()
    processing_helper.print_with_time(hash_table + ' loaded')

    cur.execute(create_track_sql)
    con.commit()
    cur.execute(insert_track_sql)
    con.commit()
    processing_helper.print_with_time(track_table + ' updated with new')

    cur.execute(create_change_sql)
    con.commit()
    cur.execute(insert_change_sql)
    con.commit()
    processing_helper.print_with_time(change_table + ' updated with new')
    cur.execute(insert_change_sql2)
    con.commit()
    processing_helper.print_with_time(change_table + ' updated with old')

    cur.execute(delete_track_sql)
    con.commit()
    processing_helper.print_with_time(track_table + ' missing deleted')

    cur.execute(update_change_sql)
    con.commit()
    processing_helper.print_with_time(change_table + ' C rows updated')

    cur.execute(stat_view_sql)
    con.commit()
    cur.execute(current_view_sql)
    con.commit()

    con.close()

    processing_helper.print_with_time(target_table + ' processing completed')


##### API FUNCTIONS - Maybe in the future #####

def get_datasets():
    client = Socrata(
        source_name,
        api_token,
        username=api_user,
        password=api_pass,
        timeout=10
    )
    res = client.datasets()
    client.close()


def reset_target_table(target_table):
    con = mysql.connector.connect(
        host=target_host,
        port=target_port,
        user=target_user,
        password=target_pass,
        database=target_schema
    )
    cur = con.cursor(dictionary=True, buffered=True)

    cur.execute("truncate table " + target_schema + "." + target_table + "_json")

    cur.execute("truncate table " + target_schema + "." + target_table)

    sql = """
        delete from shrd.api_get_position
        where source_name = %(source_name)s
          and target_schema = %(target_schema)s
          and target_table = %(target_table)s
        """
    cur.execute(sql, {'source_name': source_name,
                      'target_schema': target_schema,
                      'target_table': target_table})

    con.commit()
    con.close()
    processing_helper.print_with_time(target_table + ' reset')


def refresh_target_table(target_table, refresh_type='complete', limit=50000, run_seconds=30):
    start_time = datetime.now()
    stop_time = start_time + timedelta(seconds=run_seconds)
    processing_helper.print_with_time("start_time:", str(start_time))
    processing_helper.print_with_time("run_seconds:", str(run_seconds))
    processing_helper.print_with_time("stop_time:", str(stop_time))

    con = mysql.connector.connect(
        host=target_host,
        port=target_port,
        user=target_user,
        password=target_pass,
        database=target_schema
    )
    cur = con.cursor(dictionary=True, buffered=True)

    # Check for last socrata_id extracted
    sql = """
        select count(*) as cnt, max(json_position->>"$.socrata_id") as socrata_id
        from shrd.api_get_position_v j
        where source_name = %(source_name)s
          and target_schema = %(target_schema)s
          and target_table = %(target_table)s
          and refresh_type = %(refresh_type)s
        LIMIT 0, 1
        """
    cur.execute(sql, {'source_name': source_name,
                      'target_schema': target_schema,
                      'target_table': target_table,
                      'refresh_type': refresh_type})
    socrata = cur.fetchone()

    client = Socrata(
        source_name,
        api_token,
        username=api_user,
        password=api_pass,
        timeout=10
    )
    if socrata["cnt"] == 0:
        # no rows after a reset, so first extract will not have a where clause
        socrata_id = get_target_table_page(client, con, target_table, refresh_type, limit)
    else:
        processing_helper.print_with_time("start with socrata_id:" + str(socrata["socrata_id"]))
        socrata_id = get_target_table_page(client, con, target_table, refresh_type, limit, socrata["socrata_id"])

    while socrata_id is not None:
        seconds_left = math.floor((stop_time - datetime.now()).total_seconds())
        if seconds_left < 1:
            processing_helper.print_with_time("RAN OUT OF TIME")
            socrata_id = None
            break

        sql = "call %(proc)s(now() + INTERVAL %(run_seconds)s second)" \
              % {'proc': target_schema + ".process_" + target_table + "_json", 'run_seconds': seconds_left}
        cur.execute(sql)

        socrata_id = get_target_table_page(client, con, target_table, refresh_type, limit, socrata_id)
        con.commit()

    con.close()


def get_target_table_page(client, con, target_table, refresh_type, limit, socrata_id=None):
    if socrata_id == None or socrata_id == '':
        json_result = client.get(table_to_resource[target_table], limit=limit, offset=0, select=':id',
                                 order='":id" ASC')
    else:
        where_clause = ":id > '" + socrata_id + "'"
        processing_helper.print_with_time("where_clause: " + str(where_clause))
        json_result = client.get(table_to_resource[target_table], limit=limit, offset=0, select=':id',
                                 order='":id" ASC', where=where_clause)
    result_count = len(json_result)
    processing_helper.print_with_time(json_result)

    if result_count == 0:
        processing_helper.print_with_time("No results in get")
        processing_helper.print_with_time("STATUS:")
        processing_helper.print_with_time("COMPLETE!")
        return None

    cur = con.cursor(dictionary=True, buffered=True)

    sql = "insert into " + target_schema + "." + target_table + "_json (json_result) values (%(json_result)s)"
    cur.execute(sql, {'json_result': json.dumps(json_result)})

    socrata_ids = [x[':id'] for x in json_result]
    min_socrata_id = min(socrata_ids)
    max_socrata_id = max(socrata_ids)
    processing_helper.print_with_time("min_socrata_id: " + min_socrata_id + " max_socrata_id: " + max_socrata_id)

    json_position = {"socrata_id": max_socrata_id, "result_count": result_count}
    sql = """
    insert into shrd.api_get_position 
    (  source_name,    target_schema,    target_table,    refresh_type,   connection_id,   json_position ) 
    values 
    (%(source_name)s,%(target_schema)s,%(target_table)s,%(refresh_type)s,connection_id(),%(json_position)s)
    """
    cur.execute(sql, {'source_name': source_name, 'target_schema': target_schema, 'target_table': target_table,
                      'refresh_type': refresh_type, 'json_position': json.dumps(json_position)})

    con.commit()

    processing_helper.print_with_time("extracted thru socrata_id:" + str(max_socrata_id))

    return max_socrata_id

if __name__ == "__main__":

    # download_target_csv("cf_disclosure_report")
    # load_target_csv("cf_disclosure_report")
    process_target_table("cf_disclosure_report")


    # statement = """
    # create table import_ny.example
    # (id serial);
    # create table import_ny.example_2
    # (id serial);
    # drop table import_ny.example;"""
    #
    # con = psycopg2.connect(host=target_host, port=target_port, user=target_user, password=target_pass, database=target_schema)
    #
    # cur = con.cursor()
    #
    # cur.execute(statement)
    # con.commit()