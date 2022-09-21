### Transaction Data
DROP TABLE IF EXISTS nxsidx_data_ingest.transaction_data_incoming;
CREATE TABLE nxsidx_data_ingest.transaction_data_incoming
(
    FILER_ID               int          NOT NULL,
    FILER_PREVIOUS_ID      varchar(10)  NOT NULL,
    CAND_COMM_NAME         varchar(100) NOT NULL,
    ELECTION_YEAR          int          NOT NULL,
    ELECTION_TYPE          varchar(100) NOT NULL,
    COUNTY_DESC            varchar(255) NOT NULL,
    FILING_ABBREV          varchar(1)   NOT NULL,
    FILING_DESC            varchar(80)  NOT NULL,
    R_AMEND                varchar(1)   NOT NULL,
    FILING_CAT_DESC        varchar(80)  NOT NULL,
    FILING_SCHED_ABBREV    varchar(5)   NOT NULL,
    FILING_SCHED_DESC      varchar(80)  NOT NULL,
    LOAN_LIB_NUMBER        varchar(100) NOT NULL,
    TRANS_NUMBER           varchar(100) NOT NULL,
    TRANS_MAPPING          varchar(100) NOT NULL,
    SCHED_DATE             varchar(10)  NOT NULL,
    ORG_DATE               varchar(10)  NOT NULL,
    CNTRBR_TYPE_DESC       varchar(80)  NOT NULL,
    CNTRBN_TYPE_DESC       varchar(80)  NOT NULL,
    TRANSFER_TYPE_DESC     varchar(199) NOT NULL,
    RECEIPT_TYPE_DESC      varchar(80)  NOT NULL,
    RECEIPT_CODE_DESC      varchar(80)  NOT NULL,
    PURPOSE_CODE_DESC      varchar(80)  NOT NULL,
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
    PAYMENT_TYPE_DESC      varchar(80)  NOT NULL,
    PAY_NUMBER             varchar(30)  NOT NULL,
    OWED_AMT               varchar(8)   NOT NULL,
    ORG_AMT                varchar(12)  NOT NULL,
    LOAN_OTHER_DESC        varchar(80)  NOT NULL,
    TRANS_EXPLNTN          varchar(255) NOT NULL,
    R_ITEMIZED             varchar(1)   NOT NULL,
    R_LIABILITY            varchar(1)   NOT NULL,
    ELECTION_YEAR_R        varchar(4)   NOT NULL,
    OFFICE_DESC            varchar(100) NOT NULL,
    DISTRICT               varchar(40)  NOT NULL,
    DIST_OFF_CAND_BAL_PROP varchar(500) NOT NULL,
    TRIMM_CONTROL          varchar(5)   NULL,
    ROW_HASH               varchar(255) NULL
);

DROP TABLE IF EXISTS nxsidx_data_ingest.nys_transaction_data_source;
CREATE TABLE nxsidx_data_ingest.nys_transaction_data_source
(
    FILER_ID               int          NOT NULL,
    FILER_PREVIOUS_ID      varchar(10)  NOT NULL,
    CAND_COMM_NAME         varchar(100) NOT NULL,
    ELECTION_YEAR          int          NOT NULL,
    ELECTION_TYPE          varchar(100) NOT NULL,
    COUNTY_DESC            varchar(255) NOT NULL,
    FILING_ABBREV          varchar(1)   NOT NULL,
    FILING_DESC            varchar(80)  NOT NULL,
    R_AMEND                varchar(1)   NOT NULL,
    FILING_CAT_DESC        varchar(80)  NOT NULL,
    FILING_SCHED_ABBREV    varchar(5)   NOT NULL,
    FILING_SCHED_DESC      varchar(80)  NOT NULL,
    LOAN_LIB_NUMBER        varchar(100) NOT NULL,
    TRANS_NUMBER           varchar(100) NOT NULL,
    TRANS_MAPPING          varchar(100) NOT NULL,
    SCHED_DATE             varchar(10)  NOT NULL,
    ORG_DATE               varchar(10)  NOT NULL,
    CNTRBR_TYPE_DESC       varchar(80)  NOT NULL,
    CNTRBN_TYPE_DESC       varchar(80)  NOT NULL,
    TRANSFER_TYPE_DESC     varchar(200) NOT NULL,
    RECEIPT_TYPE_DESC      varchar(80)  NOT NULL,
    RECEIPT_CODE_DESC      varchar(80)  NOT NULL,
    PURPOSE_CODE_DESC      varchar(80)  NOT NULL,
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
    PAYMENT_TYPE_DESC      varchar(80)  NOT NULL,
    PAY_NUMBER             varchar(30)  NOT NULL,
    OWED_AMT               varchar(8)   NOT NULL,
    ORG_AMT                varchar(12)  NOT NULL,
    LOAN_OTHER_DESC        varchar(80)  NOT NULL,
    TRANS_EXPLNTN          varchar(255) NOT NULL,
    R_ITEMIZED             varchar(1)   NOT NULL,
    R_LIABILITY            varchar(1)   NOT NULL,
    ELECTION_YEAR_R        varchar(4)   NOT NULL,
    OFFICE_DESC            varchar(100) NOT NULL,
    DISTRICT               varchar(40)  NOT NULL,
    DIST_OFF_CAND_BAL_PROP varchar(500) NOT NULL,
    TRIMM_CONTROL          varchar(5)   NULL,
    ROW_HASH               varchar(255) NOT NULL,
    IMPORTED_TIMESTAMP     datetime     NOT NULL
);

DROP TABLE IF EXISTS nxsidx_data_ingest.nys_transaction_data_child;
CREATE TABLE nxsidx_data_ingest.nys_transaction_data_child
(
    unique_id                                    int AUTO_INCREMENT
        PRIMARY KEY,
    row_hash_fk                                  varchar(255) NULL,
    filer_id                                     int          NULL,
    filer_previous_id                            varchar(10)  NULL,
    candidate_committee_name                     varchar(100) NULL,
    election_year                                int          NULL,
    election_type                                varchar(100) NULL,
    county_description                           varchar(255) NULL,
    filing_abbreviation                          varchar(1)   NULL,
    filing_description                           varchar(80)  NULL,
    is_amended                                   varchar(1)   NULL,
    filing_category_description                  varchar(80)  NULL,
    filing_schedule_abbreviation                 varchar(5)   NULL,
    filing_schedule_description                  varchar(80)  NULL,
    loan_liability_id                            varchar(100) NULL,
    transaction_number                           varchar(100) NULL,
    transaction_mapping                          varchar(100) NULL,
    transaction_date                             date         NULL,
    transaction_parent_date                      varchar(10)  NULL,
    contributor_type                             varchar(80)  NULL,
    contribution_type                            varchar(80)  NULL,
    transfer_type                                varchar(200) NULL,
    receipt_type                                 varchar(80)  NULL,
    receipt_code                                 varchar(80)  NULL,
    purpose_code                                 varchar(80)  NULL,
    is_subcontractor                             varchar(1)   NULL,
    donor_organization_name                      varchar(255) NULL,
    donor_first_name                             varchar(100) NULL,
    donor_middle_name                            varchar(100) NULL,
    donor_last_name                              varchar(100) NULL,
    donor_address                                varchar(100) NULL,
    donor_city                                   varchar(100) NULL,
    donor_state                                  varchar(30)  NULL,
    donor_zip                                    varchar(20)  NULL,
    donor_country                                varchar(20)  NULL,
    payment_type                                 varchar(80)  NULL,
    payment_number                               varchar(30)  NULL,
    owed_amount                                  varchar(50)  NULL,
    original_amount                              varchar(50)  NULL,
    loan_type                                    varchar(80)  NULL,
    transaction_explanation                      varchar(255) NULL,
    is_itemized                                  varchar(1)   NULL,
    is_liability                                 varchar(1)   NULL,
    candidate_election_year                      varchar(4)   NULL,
    candidate_office                             varchar(100) NULL,
    candidate_district                           varchar(40)  NULL,
    district_office_candidate_ballot_proposition varchar(255) NULL,
    imported_timestamp                           timestamp    NULL,
    updated_timestamp                            timestamp    NULL
);

## Load in new campaign disclosure data

LOAD DATA LOCAL INFILE '/mnt/volume_nyc3_01/var/lib/mysql-files/webapp/import_ny/NYS_Campaign_Finance_Disclosure_Reports.csv'
    INTO TABLE nxsidx_data_ingest.transaction_data_incoming
    FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' ESCAPED BY '\b' LINES TERMINATED BY '\n' IGNORE 1 LINES
    (FILER_ID,
     FILER_PREVIOUS_ID,
     CAND_COMM_NAME,
     ELECTION_YEAR,
     ELECTION_TYPE,
     COUNTY_DESC,
     FILING_ABBREV,
     FILING_DESC,
     R_AMEND,
     FILING_CAT_DESC,
     FILING_SCHED_ABBREV,
     FILING_SCHED_DESC,
     LOAN_LIB_NUMBER,
     TRANS_NUMBER,
     TRANS_MAPPING,
     SCHED_DATE,
     ORG_DATE,
     CNTRBR_TYPE_DESC,
     CNTRBN_TYPE_DESC,
     TRANSFER_TYPE_DESC,
     RECEIPT_TYPE_DESC,
     RECEIPT_CODE_DESC,
     PURPOSE_CODE_DESC,
     R_SUBCONTRACTOR,
     FLNG_ENT_NAME,
     FLNG_ENT_FIRST_NAME,
     FLNG_ENT_MIDDLE_NAME,
     FLNG_ENT_LAST_NAME,
     FLNG_ENT_ADD1,
     FLNG_ENT_CITY,
     FLNG_ENT_STATE,
     FLNG_ENT_ZIP,
     FLNG_ENT_COUNTRY,
     PAYMENT_TYPE_DESC,
     PAY_NUMBER,
     OWED_AMT,
     ORG_AMT,
     LOAN_OTHER_DESC,
     TRANS_EXPLNTN,
     R_ITEMIZED,
     R_LIABILITY,
     ELECTION_YEAR_R,
     OFFICE_DESC,
     DISTRICT,
     DIST_OFF_CAND_BAL_PROP,
     @var)
    SET TRIMM_CONTROL = TRIM(TRAILING '\r' FROM @var),
        FILER_ID = UPPER(FILER_ID), FILER_PREVIOUS_ID = UPPER(FILER_PREVIOUS_ID), CAND_COMM_NAME = UPPER(CAND_COMM_NAME),
        ELECTION_YEAR = UPPER(ELECTION_YEAR), ELECTION_TYPE = UPPER(ELECTION_TYPE), COUNTY_DESC = UPPER(COUNTY_DESC),
        FILING_ABBREV = UPPER(FILING_ABBREV), FILING_DESC = UPPER(FILING_DESC), R_AMEND = UPPER(R_AMEND),
        FILING_CAT_DESC = UPPER(FILING_CAT_DESC), FILING_SCHED_ABBREV = UPPER(FILING_SCHED_ABBREV), FILING_SCHED_DESC = UPPER(FILING_SCHED_DESC),
        LOAN_LIB_NUMBER = UPPER(LOAN_LIB_NUMBER), TRANS_NUMBER = UPPER(TRANS_NUMBER), TRANS_MAPPING = UPPER(TRANS_MAPPING),
        SCHED_DATE = UPPER(SCHED_DATE), ORG_DATE = UPPER(ORG_DATE), CNTRBR_TYPE_DESC = UPPER(CNTRBR_TYPE_DESC),
        CNTRBN_TYPE_DESC = UPPER(CNTRBN_TYPE_DESC), TRANSFER_TYPE_DESC = UPPER(TRANSFER_TYPE_DESC),
        RECEIPT_TYPE_DESC = UPPER(RECEIPT_TYPE_DESC), RECEIPT_CODE_DESC = UPPER(RECEIPT_CODE_DESC),
        PURPOSE_CODE_DESC = UPPER(PURPOSE_CODE_DESC), R_SUBCONTRACTOR = UPPER(R_SUBCONTRACTOR),
        FLNG_ENT_NAME = UPPER(FLNG_ENT_NAME), FLNG_ENT_FIRST_NAME = UPPER(FLNG_ENT_FIRST_NAME),
        FLNG_ENT_MIDDLE_NAME = UPPER(FLNG_ENT_MIDDLE_NAME), FLNG_ENT_LAST_NAME = UPPER(FLNG_ENT_LAST_NAME),
        FLNG_ENT_ADD1 = UPPER(FLNG_ENT_ADD1), FLNG_ENT_CITY = UPPER(FLNG_ENT_CITY),
        FLNG_ENT_STATE = UPPER(FLNG_ENT_STATE), FLNG_ENT_ZIP = UPPER(FLNG_ENT_ZIP),
        FLNG_ENT_COUNTRY = UPPER(FLNG_ENT_COUNTRY), PAYMENT_TYPE_DESC = UPPER(PAYMENT_TYPE_DESC),
        PAY_NUMBER = UPPER(PAY_NUMBER), OWED_AMT = UPPER(OWED_AMT), ORG_AMT = UPPER(ORG_AMT),
        LOAN_OTHER_DESC = UPPER(LOAN_OTHER_DESC), TRANS_EXPLNTN = UPPER(TRANS_EXPLNTN),
        R_ITEMIZED = UPPER(R_ITEMIZED), R_LIABILITY = UPPER(R_LIABILITY), ELECTION_YEAR_R = UPPER(ELECTION_YEAR_R),
        OFFICE_DESC = UPPER(OFFICE_DESC), DISTRICT = UPPER(DISTRICT), DIST_OFF_CAND_BAL_PROP = UPPER(DIST_OFF_CAND_BAL_PROP);

## Calculate row hash

UPDATE nxsidx_data_ingest.transaction_data_incoming
SET ROW_HASH = (SHA1(
        CONCAT_WS(FILER_ID, FILER_PREVIOUS_ID, CAND_COMM_NAME, ELECTION_YEAR, ELECTION_TYPE, COUNTY_DESC, FILING_ABBREV,
                  FILING_DESC, R_AMEND, FILING_CAT_DESC, FILING_SCHED_ABBREV, FILING_SCHED_DESC, LOAN_LIB_NUMBER,
                  TRANS_NUMBER, TRANS_MAPPING, SCHED_DATE, ORG_DATE, CNTRBR_TYPE_DESC, CNTRBN_TYPE_DESC,
                  TRANSFER_TYPE_DESC, RECEIPT_TYPE_DESC, RECEIPT_CODE_DESC, PURPOSE_CODE_DESC, R_SUBCONTRACTOR,
                  FLNG_ENT_NAME, FLNG_ENT_FIRST_NAME, FLNG_ENT_MIDDLE_NAME, FLNG_ENT_LAST_NAME, FLNG_ENT_ADD1,
                  FLNG_ENT_CITY, FLNG_ENT_STATE, FLNG_ENT_ZIP, FLNG_ENT_COUNTRY, PAYMENT_TYPE_DESC, PAY_NUMBER,
                  OWED_AMT, ORG_AMT, LOAN_OTHER_DESC, TRANS_EXPLNTN, R_ITEMIZED, R_LIABILITY, ELECTION_YEAR_R,
                  OFFICE_DESC, DISTRICT, DIST_OFF_CAND_BAL_PROP)))
WHERE 1 = 1;


## Insert new data into new data tables

INSERT INTO nxsidx_data_ingest.nys_transaction_data_source (FILER_ID, FILER_PREVIOUS_ID, CAND_COMM_NAME, ELECTION_YEAR,
                                                            ELECTION_TYPE, COUNTY_DESC, FILING_ABBREV, FILING_DESC,
                                                            R_AMEND,
                                                            FILING_CAT_DESC, FILING_SCHED_ABBREV, FILING_SCHED_DESC,
                                                            LOAN_LIB_NUMBER, TRANS_NUMBER, TRANS_MAPPING, SCHED_DATE,
                                                            ORG_DATE,
                                                            CNTRBR_TYPE_DESC, CNTRBN_TYPE_DESC, TRANSFER_TYPE_DESC,
                                                            RECEIPT_TYPE_DESC, RECEIPT_CODE_DESC, PURPOSE_CODE_DESC,
                                                            R_SUBCONTRACTOR, FLNG_ENT_NAME, FLNG_ENT_FIRST_NAME,
                                                            FLNG_ENT_MIDDLE_NAME, FLNG_ENT_LAST_NAME, FLNG_ENT_ADD1,
                                                            FLNG_ENT_CITY, FLNG_ENT_STATE, FLNG_ENT_ZIP,
                                                            FLNG_ENT_COUNTRY,
                                                            PAYMENT_TYPE_DESC, PAY_NUMBER, OWED_AMT, ORG_AMT,
                                                            LOAN_OTHER_DESC,
                                                            TRANS_EXPLNTN, R_ITEMIZED, R_LIABILITY, ELECTION_YEAR_R,
                                                            OFFICE_DESC,
                                                            DISTRICT, DIST_OFF_CAND_BAL_PROP, ROW_HASH,
                                                            IMPORTED_TIMESTAMP)
SELECT FILER_ID, FILER_PREVIOUS_ID, CAND_COMM_NAME, ELECTION_YEAR, ELECTION_TYPE, COUNTY_DESC, FILING_ABBREV,
       FILING_DESC, R_AMEND, FILING_CAT_DESC, FILING_SCHED_ABBREV, FILING_SCHED_DESC, LOAN_LIB_NUMBER, TRANS_NUMBER,
       TRANS_MAPPING, SCHED_DATE, ORG_DATE, CNTRBR_TYPE_DESC, CNTRBN_TYPE_DESC, TRANSFER_TYPE_DESC, RECEIPT_TYPE_DESC,
       RECEIPT_CODE_DESC, PURPOSE_CODE_DESC, R_SUBCONTRACTOR, FLNG_ENT_NAME, FLNG_ENT_FIRST_NAME, FLNG_ENT_MIDDLE_NAME,
       FLNG_ENT_LAST_NAME, FLNG_ENT_ADD1, FLNG_ENT_CITY, FLNG_ENT_STATE, FLNG_ENT_ZIP, FLNG_ENT_COUNTRY,
       PAYMENT_TYPE_DESC, PAY_NUMBER, OWED_AMT, ORG_AMT, LOAN_OTHER_DESC, TRANS_EXPLNTN, R_ITEMIZED, R_LIABILITY,
       ELECTION_YEAR_R, OFFICE_DESC, DISTRICT, DIST_OFF_CAND_BAL_PROP, ROW_HASH, CURRENT_TIMESTAMP
FROM nxsidx_data_ingest.transaction_data_incoming;

INSERT INTO nxsidx_data_ingest.nys_transaction_data_child (row_hash_fk, filer_id, filer_previous_id,
                                                           candidate_committee_name,
                                                           election_year, election_type, county_description,
                                                           filing_abbreviation,
                                                           filing_description, is_amended, filing_category_description,
                                                           filing_schedule_abbreviation, filing_schedule_description,
                                                           loan_liability_id, transaction_number, transaction_mapping,
                                                           transaction_date, transaction_parent_date, contributor_type,
                                                           contribution_type, transfer_type, receipt_type, receipt_code,
                                                           purpose_code, is_subcontractor, donor_organization_name,
                                                           donor_first_name, donor_middle_name, donor_last_name,
                                                           donor_address,
                                                           donor_city, donor_state, donor_zip, donor_country,
                                                           payment_type,
                                                           payment_number, owed_amount, original_amount, loan_type,
                                                           transaction_explanation, is_itemized, is_liability,
                                                           candidate_election_year, candidate_office,
                                                           candidate_district,
                                                           district_office_candidate_ballot_proposition,
                                                           imported_timestamp,
                                                           updated_timestamp)
SELECT ROW_HASH, FILER_ID, FILER_PREVIOUS_ID, CAND_COMM_NAME, ELECTION_YEAR, ELECTION_TYPE, COUNTY_DESC, FILING_ABBREV,
       FILING_DESC, R_AMEND, FILING_CAT_DESC, FILING_SCHED_ABBREV, FILING_SCHED_DESC, LOAN_LIB_NUMBER, TRANS_NUMBER,
       TRANS_MAPPING, STR_TO_DATE(SCHED_DATE, '%m/%d/%Y'),
       COALESCE(NULLIF(STR_TO_DATE(ORG_DATE, '%m/%d/%Y'), '0000-00-00'), ''), CNTRBR_TYPE_DESC, CNTRBN_TYPE_DESC,
       TRANSFER_TYPE_DESC, RECEIPT_TYPE_DESC, RECEIPT_CODE_DESC, PURPOSE_CODE_DESC, R_SUBCONTRACTOR, FLNG_ENT_NAME,
       FLNG_ENT_FIRST_NAME, FLNG_ENT_MIDDLE_NAME, FLNG_ENT_LAST_NAME, FLNG_ENT_ADD1, FLNG_ENT_CITY, FLNG_ENT_STATE,
       FLNG_ENT_ZIP, FLNG_ENT_COUNTRY, PAYMENT_TYPE_DESC, PAY_NUMBER, OWED_AMT, ORG_AMT, LOAN_OTHER_DESC, TRANS_EXPLNTN,
       R_ITEMIZED, R_LIABILITY, ELECTION_YEAR_R, OFFICE_DESC, DISTRICT, DIST_OFF_CAND_BAL_PROP, CURRENT_TIMESTAMP,
       CURRENT_TIMESTAMP
FROM nxsidx_data_ingest.nys_transaction_data_source;


## Create all of the indexes we will want on the new data

CREATE INDEX nxsidx_idx_td_source_row_hash ON nxsidx_data_ingest.nys_transaction_data_source (ROW_HASH);

CREATE INDEX nxsidx_idx_td_row_hash ON nxsidx_data_ingest.nys_transaction_data_child (row_hash_fk);
CREATE INDEX nxsidx_idx_td_child_lname_fname ON nxsidx_data_ingest.nys_transaction_data_child (donor_last_name, donor_first_name);
CREATE INDEX nxsidx_idx_td_child_committee_name ON nxsidx_data_ingest.nys_transaction_data_child (candidate_committee_name);
CREATE INDEX nxsidx_idx_td_child_org_name ON nxsidx_data_ingest.nys_transaction_data_child (donor_organization_name);
CREATE INDEX nxsidx_idx_td_child_tx_date ON nxsidx_data_ingest.nys_transaction_data_child (transaction_date);
CREATE INDEX nxsidx_idx_data_tx_type
    ON nxsidx_ny.nys_transaction_data_child (filing_schedule_description);
CREATE INDEX nxsidx_idx_td_child_filer_id ON nxsidx_data_ingest.nys_transaction_data_child (filer_id);
CREATE INDEX nxsidx_idx_td_child_filer_txdate ON nxsidx_data_ingest.nys_transaction_data_child (filer_id, transaction_date);
CREATE INDEX nxsidx_idx_td_child_filer_filing ON nxsidx_data_ingest.nys_transaction_data_child (filer_id, filing_abbreviation);
CREATE INDEX nxsidx_idx_td_child_eyear ON nxsidx_data_ingest.nys_transaction_data_child (election_year);
CREATE INDEX nxsidx_idx_td_child_zip ON nxsidx_data_ingest.nys_transaction_data_child (donor_zip);
CREATE INDEX nxsidx_idx_td_child_year_zip ON nxsidx_data_ingest.nys_transaction_data_child (election_year, donor_zip);


### Filer data

DROP TABLE IF EXISTS nxsidx_data_ingest.nys_filer_data_incoming;
CREATE TABLE nxsidx_data_ingest.nys_filer_data_incoming
(
    ID                    int AUTO_INCREMENT
        PRIMARY KEY,
    FILER_ID              int          NOT NULL,
    FILER_NAME            varchar(100) NOT NULL,
    COMPLIANCE_TYPE_DESC  varchar(10)  NOT NULL DEFAULT '',
    FILER_TYPE_DESC       varchar(10)  NOT NULL DEFAULT '',
    FILER_STATUS          varchar(10)  NOT NULL DEFAULT '',
    COMMITTEE_TYPE_DESC   varchar(80)  NOT NULL DEFAULT '',
    OFFICE_DESC           varchar(50)  NOT NULL DEFAULT '',
    DISTRICT              varchar(20)  NOT NULL DEFAULT '',
    COUNTY_DESC           varchar(20)  NOT NULL DEFAULT '',
    MUNICIPALITY_DESC     varchar(30)  NOT NULL DEFAULT '',
    TREASURER_FIRST_NAME  varchar(100) NOT NULL DEFAULT '',
    TREASURER_MIDDLE_NAME varchar(100) NOT NULL DEFAULT '',
    TREASURER_LAST_NAME   varchar(100) NOT NULL DEFAULT '',
    ADDRESS               varchar(100) NOT NULL DEFAULT '',
    CITY                  varchar(40)  NOT NULL DEFAULT '',
    STATE                 varchar(2)   NOT NULL DEFAULT '',
    ZIPCODE               varchar(10)  NOT NULL DEFAULT '',
    TRIMM_CONTROL         varchar(5)   NULL,
    ROW_HASH              varchar(255) NULL
);

DROP TABLE IF EXISTS nxsidx_data_ingest.nys_filer_data;
CREATE TABLE nxsidx_data_ingest.nys_filer_data
(
    id                    int AUTO_INCREMENT
        PRIMARY KEY,
    filer_id              int          NOT NULL,
    filer_name            varchar(100) NOT NULL,
    compliance_type       varchar(10)  NOT NULL,
    filer_type            varchar(10)  NOT NULL,
    filer_status          varchar(10)  NOT NULL,
    committee_type        varchar(80)  NOT NULL,
    office_desc           varchar(50)  NOT NULL,
    district              varchar(20)  NOT NULL,
    county_desc           varchar(20)  NOT NULL,
    municipality_desc     varchar(30)  NOT NULL,
    treasurer_first_name  varchar(100) NOT NULL,
    treasurer_middle_name varchar(100) NOT NULL,
    treasurer_last_name   varchar(100) NOT NULL,
    treasurer_address     varchar(100) NOT NULL,
    treasurer_city        varchar(40)  NOT NULL,
    treasurer_state       varchar(2)   NOT NULL,
    treasurer_zip         varchar(10)  NOT NULL,
    row_hash              varchar(255) NOT NULL,
    imported_timestamp    datetime     NOT NULL
);


## Load new filer data

LOAD DATA LOCAL INFILE '/mnt/volume_nyc3_01/var/lib/mysql-files/webapp/import_ny/NYS_Campaign_Finance_Filers.csv'
    INTO TABLE nxsidx_data_ingest.nys_filer_data_incoming
    FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' ESCAPED BY '\b' LINES TERMINATED BY '\n' IGNORE 1 LINES
    (FILER_ID, FILER_NAME, COMPLIANCE_TYPE_DESC, FILER_TYPE_DESC, FILER_STATUS, COMMITTEE_TYPE_DESC, OFFICE_DESC,
     DISTRICT, COUNTY_DESC, MUNICIPALITY_DESC, TREASURER_FIRST_NAME, TREASURER_MIDDLE_NAME, TREASURER_LAST_NAME,
     ADDRESS, CITY, STATE,
     ZIPCODE)
    SET TRIMM_CONTROL = TRIM(TRAILING '\r' FROM @var), FILER_ID = UPPER(FILER_ID), FILER_NAME = UPPER(FILER_NAME),
        COMPLIANCE_TYPE_DESC = UPPER(COMPLIANCE_TYPE_DESC), FILER_TYPE_DESC = UPPER(FILER_TYPE_DESC),
        FILER_STATUS = UPPER(FILER_STATUS), COMMITTEE_TYPE_DESC = UPPER(COMMITTEE_TYPE_DESC),
        OFFICE_DESC = UPPER(OFFICE_DESC), DISTRICT = UPPER(DISTRICT), COUNTY_DESC = UPPER(COUNTY_DESC),
        MUNICIPALITY_DESC = UPPER(MUNICIPALITY_DESC), TREASURER_FIRST_NAME = UPPER(TREASURER_FIRST_NAME),
        TREASURER_MIDDLE_NAME = UPPER(TREASURER_MIDDLE_NAME), TREASURER_LAST_NAME = UPPER(TREASURER_LAST_NAME),
        ADDRESS = UPPER(ADDRESS), CITY = UPPER(CITY), STATE = UPPER(STATE), ZIPCODE = UPPER(ZIPCODE);

#Calculate row hash for table
UPDATE nxsidx_data_ingest.nys_filer_data_incoming
SET ROW_HASH = (SHA1(
        CONCAT_WS(FILER_ID, FILER_NAME, COMPLIANCE_TYPE_DESC, FILER_TYPE_DESC, FILER_STATUS, COMMITTEE_TYPE_DESC,
                  OFFICE_DESC, DISTRICT, COUNTY_DESC, MUNICIPALITY_DESC, TREASURER_FIRST_NAME, TREASURER_MIDDLE_NAME,
                  TREASURER_LAST_NAME, ADDRESS, CITY, STATE, ZIPCODE)))
WHERE 1 = 1;


## Insert new data into new filer_data table

INSERT INTO nxsidx_data_ingest.nys_filer_data (filer_id, filer_name, compliance_type, filer_type, filer_status,
                                               committee_type, office_desc, district, county_desc, municipality_desc,
                                               treasurer_first_name, treasurer_middle_name, treasurer_last_name,
                                               treasurer_address,
                                               treasurer_city, treasurer_state, treasurer_zip, row_hash,
                                               imported_timestamp)
SELECT FILER_ID, FILER_NAME, COMPLIANCE_TYPE_DESC, FILER_TYPE_DESC, FILER_STATUS, COMMITTEE_TYPE_DESC,
       OFFICE_DESC, DISTRICT, COUNTY_DESC, MUNICIPALITY_DESC, TREASURER_FIRST_NAME, TREASURER_MIDDLE_NAME,
       TREASURER_LAST_NAME, ADDRESS, CITY, STATE, ZIPCODE, ROW_HASH, CURRENT_TIMESTAMP
FROM nxsidx_data_ingest.nys_filer_data_incoming;

CREATE INDEX nxsidx_idx_filer_data_cmte_type
    ON nxsidx_data_ingest.nys_filer_data (committee_type);

CREATE INDEX nxsidx_idx_filer_data_row_hash
    ON nxsidx_data_ingest.nys_filer_data (row_hash);

## Hot swap tables by rename, adding date to the old table backup
SET @sql = CONCAT('RENAME TABLE nxsidx_ny.nys_filer_data TO `nxsidx_backup`.`nys_filer_data_',
                  DATE_FORMAT(CURDATE(), '%Y-%m-%d'), '`, ',
                  'nxsidx_data_ingest.nys_filer_data TO `nxsidx_ny`.`nys_filer_data`, ',
                  'nxsidx_ny.nys_transaction_data_child TO `nxsidx_backup`.`nys_transaction_data_child_',
                  DATE_FORMAT(CURDATE(), '%Y-%m-%d'), '`, ',
                  'nxsidx_data_ingest.nys_transaction_data_child TO `nxsidx_ny`.`nys_transaction_data_child`, ',
                  'nxsidx_ny.nys_transaction_data_source TO `nxsidx_backup`.`nys_transaction_data_source_',
                  DATE_FORMAT(CURDATE(), '%Y-%m-%d'), '`, ',
                  'nxsidx_data_ingest.nys_transaction_data_source TO `nxsidx_ny`.`nys_transaction_data_source`;');

PREPARE stmt FROM @sql;
EXECUTE stmt;


## Back up summary filing tables
SET @sql = CONCAT('CREATE TABLE `nxsidx_backup`.`nys_transaction_data_summary_by_filing_backup_',
                  DATE_FORMAT(CURDATE(), '%Y-%m-%d'), '`
    SELECT * FROM nxsidx_ny.nys_transaction_data_filers_cash_on_hand;');

PREPARE stmt FROM @sql;
EXECUTE stmt;

SET @sql = CONCAT('CREATE TABLE `nxsidx_backup`.`nys_transaction_data_filers_cash_on_hand_backup_',
                  DATE_FORMAT(CURDATE(), '%Y-%m-%d'), '`
    SELECT * FROM nxsidx_ny.nys_transaction_data_filers_cash_on_hand;');

PREPARE stmt FROM @sql;
EXECUTE stmt;

CALL nxsidx_ny.nxsidx_generate_filer_summary_by_schedule();
CALL nxsidx_ny.nxsidx_generate_filer_cash_on_hand();
