import mysql.connector
import json
import math
from datetime import *
import urllib
import ssl
import pathlib
import os

## Set config

db_user = "nxs_admin"

with open('../conf/config.json') as json_file:
    conf = json.load(json_file)
    db_host = conf["db"]["host"]
    db_port = conf["db"]["port"]
    db_pass = conf["db"]["passwords"][db_user]
    mysql_files_location = os.getenv('MYSQL_FILES_LOCATION')

## Loads main CF dataset into DB
def load_transaction_csv():  
    """
    Sample Usage: 
    python -c"import nsxidx; nsxidx.load_transaction_csv;"
    """
    con = mysql.connector.connect(host=db_host,user=db_user,password=db_pass,
                                  database='nxsidx_data_ingest')     

    cur = con.cursor(dictionary=True,buffered=True)

    cur.execute("DROP TABLE IF EXISTS nxsidx_data_ingest.transaction_data_incoming")
    cur.execute("""
        CREATE TABLE nxsidx_data_ingest.transaction_data_incoming
        (
            FILER_ID               int          NOT NULL,
            FILER_PREVIOUS_ID      varchar(10)  NOT NULL,
            CAND_COMM_NAME         varchar(100) NOT NULL,
            ELECTION_YEAR          int          NOT NULL,
            ELECTION_TYPE          varchar(15)  NOT NULL,
            COUNTY_DESC            varchar(15)  NOT NULL,
            FILING_ABBREV          varchar(1)   NOT NULL,
            FILING_DESC            varchar(50)  NOT NULL,
            R_AMEND                varchar(1)   NOT NULL,
            FILING_CAT_DESC        varchar(10)  NOT NULL,
            FILING_SCHED_ABBREV    varchar(5)   NOT NULL,
            FILING_SCHED_DESC      varchar(50)  NOT NULL,
            LOAN_LIB_NUMBER        varchar(50)  NOT NULL,
            TRANS_NUMBER           varchar(50)  NOT NULL,
            TRANS_MAPPING          varchar(50)  NOT NULL,
            SCHED_DATE             varchar(10)  NOT NULL,
            ORG_DATE               varchar(10)  NOT NULL,
            CNTRBR_TYPE_DESC       varchar(50)  NOT NULL,
            CNTRBN_TYPE_DESC       varchar(50)  NOT NULL,
            TRANSFER_TYPE_DESC     varchar(100) NOT NULL,
            RECEIPT_TYPE_DESC      varchar(20)  NOT NULL,
            RECEIPT_CODE_DESC      varchar(30)  NOT NULL,
            PURPOSE_CODE_DESC      varchar(50)  NOT NULL,
            R_SUBCONTRACTOR        varchar(1)   NOT NULL,
            FLNG_ENT_NAME          varchar(255) NOT NULL,
            FLNG_ENT_FIRST_NAME    varchar(100) NOT NULL,
            FLNG_ENT_MIDDLE_NAME   varchar(100) NOT NULL,
            FLNG_ENT_LAST_NAME     varchar(100) NOT NULL,
            FLNG_ENT_ADD1          varchar(100) NOT NULL,
            FLNG_ENT_CITY          varchar(100) NOT NULL,
            FLNG_ENT_STATE         varchar(30)  NOT NULL,
            FLNG_ENT_ZIP           varchar(20)  NOT NULL,
            FLNG_ENT_COUNTRY       varchar(20)  NOT NULL,
            PAYMENT_TYPE_DESC      varchar(30)  NOT NULL,
            PAY_NUMBER             varchar(30)  NOT NULL,
            OWED_AMT               varchar(50)  NOT NULL,
            ORG_AMT                varchar(50)  NOT NULL,
            LOAN_OTHER_DESC        varchar(50)  NOT NULL,
            TRANS_EXPLNTN          varchar(255) NOT NULL,
            R_ITEMIZED             varchar(1)   NOT NULL,
            R_LIABILITY            varchar(1)   NOT NULL,
            ELECTION_YEAR_R        varchar(4)   NOT NULL,
            OFFICE_DESC            varchar(25)  NOT NULL,
            DISTRICT               varchar(5)   NOT NULL,
            DIST_OFF_CAND_BAL_PROP varchar(10)  NOT NULL,
            TRIMM_CONTROL          varchar(5)   NULL,
            ROW_HASH               varchar(255) NULL
        )    
    """)
    load_sql = """
    LOAD DATA INFILE '%(mysql_files_location)s/import_ny/cf_disclosure_report.csv' 
    INTO TABLE nxsidx_data_ingest.transaction_data_incoming 
        fields TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' ESCAPED BY '\b' LINES TERMINATED BY '\n' IGNORE 1 LINES 
        (filer_id,
        filer_previous_id,
        cand_comm_name,
        election_year,
        election_type,
        county_desc,
        filing_abbrev,
        filing_desc,
        r_amend,
        filing_cat_desc,
        filing_sched_abbrev,
        filing_sched_desc,
        loan_lib_number,
        trans_number,
        trans_mapping,
        sched_date,
        org_date,
        cntrbr_type_desc,
        cntrbn_type_desc,
        transfer_type_desc,
        receipt_type_desc,
        receipt_code_desc,
        purpose_code_desc,
        r_subcontractor,
        flng_ent_name,
        flng_ent_first_name,
        flng_ent_middle_name,
        flng_ent_last_name,
        flng_ent_add1,
        flng_ent_city,
        flng_ent_state,
        flng_ent_zip,
        flng_ent_country,
        payment_type_desc,
        pay_number,
        owed_amt,
        org_amt,
        loan_other_desc,
        trans_explntn,
        r_itemized,
        r_liability,
        election_year_r,
        office_desc,
        district,
        dist_off_cand_bal_prop,
        @var) 
        SET trimm_control = trim(TRAILING '\r' FROM @var), 
        filer_id = upper(filer_id), 
        filer_previous_id = upper(filer_previous_id), 
        cand_comm_name = upper(cand_comm_name), 
        election_year = upper(election_year), 
        election_type = upper(election_type), 
        county_desc = upper(county_desc), 
        filing_abbrev = upper(filing_abbrev), 
        filing_desc = upper(filing_desc), 
        r_amend = upper(r_amend), 
        filing_cat_desc = upper(filing_cat_desc), 
        filing_sched_abbrev = upper(filing_sched_abbrev), 
        filing_sched_desc = upper(filing_sched_desc), 
        loan_lib_number = upper(loan_lib_number), 
        trans_number = upper(trans_number), 
        trans_mapping = upper(trans_mapping), 
        sched_date = upper(sched_date), 
        org_date = upper(org_date), 
        cntrbr_type_desc = upper(cntrbr_type_desc), 
        cntrbn_type_desc = upper(cntrbn_type_desc), 
        transfer_type_desc = upper(transfer_type_desc), 
        receipt_type_desc = upper(receipt_type_desc), 
        receipt_code_desc = upper(receipt_code_desc), 
        purpose_code_desc = upper(purpose_code_desc), 
        r_subcontractor = upper(r_subcontractor), 
        flng_ent_name = upper(flng_ent_name), 
        flng_ent_first_name = upper(flng_ent_first_name), 
        flng_ent_middle_name = upper(flng_ent_middle_name), 
        flng_ent_last_name = upper(flng_ent_last_name), 
        flng_ent_add1 = upper(flng_ent_add1), 
        flng_ent_city = upper(flng_ent_city), 
        flng_ent_state = upper(flng_ent_state), 
        flng_ent_zip = upper(flng_ent_zip), 
        flng_ent_country = upper(flng_ent_country), 
        payment_type_desc = upper(payment_type_desc), 
        pay_number = upper(pay_number), 
        owed_amt = upper(owed_amt), 
        org_amt = upper(org_amt), 
        loan_other_desc = upper(loan_other_desc), 
        trans_explntn = upper(trans_explntn), 
        r_itemized = upper(r_itemized), 
        r_liability = upper(r_liability), 
        election_year_r = upper(election_year_r), 
        office_desc = upper(office_desc), 
        district = upper(district), 
        dist_off_cand_bal_prop = upper(dist_off_cand_bal_prop)
    """ % {"mysql_files_location": mysql_files_location}
    print(load_sql)
    cur.execute(load_sql)
    con.commit() 
    con.close() 
    print('nxsidx_data_ingest.transaction_data_incoming csv loaded')