drop view if exists nxsidx_ny.nys_transaction_data_child;
create view nxsidx_ny.nys_transaction_data_child
as select
row_hash as row_hash_fk,
convert(filer_id,UNSIGNED INTEGER) as filer_id,
filer_previous_id as filer_previous_id,
cand_comm_name as candidate_committee_name,
convert(election_year,UNSIGNED INTEGER) as election_year,
election_type as election_type,
county_desc as county_description,
filing_abbrev as filing_abbreviation,
filing_desc as filing_description,
r_amend as is_amended,
filing_cat_desc as filing_category_description,
filing_sched_abbrev as filing_schedule_abbreviation,
filing_sched_desc as filing_schedule_description,
loan_lib_number as loan_liability_id,
trans_number as transaction_number,
trans_mapping as transaction_mapping,
str_to_date(sched_date,'%m/%d/%Y') as transaction_date,
coalesce(nullif(str_to_date(org_date,'%m/%d/%Y'),'0000-00-00'),'') as transaction_parent_date,
cntrbr_type_desc as contributor_type,
cntrbn_type_desc as contribution_type,
transfer_type_desc as transfer_type,
receipt_type_desc as receipt_type,
receipt_code_desc as receipt_code,
purpose_code_desc as purpose_code,
r_subcontractor as is_subcontractor,
flng_ent_name as donor_organization_name,
flng_ent_first_name as donor_first_name,
flng_ent_middle_name as donor_middle_name,
flng_ent_last_name as donor_last_name,
flng_ent_add1 as donor_address,
flng_ent_city as donor_city,
flng_ent_state as donor_state,
flng_ent_zip as donor_zip,
flng_ent_country as donor_country,
payment_type_desc as payment_type,
pay_number as payment_number,
owed_amt as owed_amount,
CAST(org_amt AS DECIMAL(10,2)) as original_amount,
loan_other_desc as loan_type,
trans_explntn as transaction_explanation,
r_itemized as is_itemized,
r_liability as is_liability,
election_year_r as candidate_election_year,
office_desc as candidate_office,
district as candidate_district,
dist_off_cand_bal_prop as district_office_candidate_ballot_proposition,
loaded_at as imported_timestamp,
loaded_at as updated_timestamp
from import_ny.cf_disclosure_report_nodup;
 
drop view if exists nxsidx_ny.nys_filer_data;
create view nxsidx_ny.nys_filer_data
as
select
convert(filer_id,UNSIGNED INTEGER) as filer_id,
filer_name as filer_name,
compliance_type_desc as compliance_type,
filer_type_desc as filer_type,
filer_status as filer_status,
committee_type_desc as committee_type,
office_desc as office_desc,
district as district,
county_desc as county_desc,
SUBSTRING_INDEX(municipality_subdivision_desc, ',', 1) as municipality_desc,
SUBSTRING_INDEX(municipality_subdivision_desc,',', -1) as subdivision_desc,
treasurer_first_name as treasurer_first_name,
treasurer_middle_name as treasurer_middle_name,
treasurer_last_name as treasurer_last_name,
address as treasurer_address,
city as treasurer_city,
state as treasurer_state,
zipcode as treasurer_zip,
row_hash as row_hash,
loaded_at as imported_timestamp
from import_ny.cf_filer_nodup;


ALTER TABLE import_ny.cf_disclosure_report_nodup 
ADD INDEX idx_cf_disclosure_report_nodup_summary (filer_id,election_year,filing_abbrev,filing_sched_abbrev);


SET sql_mode = '';

DROP TABLE IF EXISTS nxsidx_ny.nys_transaction_data_summary_by_filing;
CREATE TABLE nxsidx_ny.nys_transaction_data_summary_by_filing
    AS
SELECT filer_id, election_year, filing_abbreviation, filing_description, contributions_ind_part, contributions_corp, contributions_other,
       contributions_inkind, other_receipts, expenditures, transfers_in, transfers_out, loans_received, loans_repayed, liabilities_forgiven, expenditures_refunded, contributions_refunded,
       liabilities_outstanding, subcontractor_payments, housekeeping_receipts, housekeeping_expenses, expense_allocation_among_candidates,
       ROUND(SUM(contributions_ind_part + contributions_corp + contributions_other + contributions_inkind + other_receipts + transfers_in + loans_received + expenditures_refunded),2) as contributions,
       ROUND(SUM(expenditures + transfers_out + loans_repayed + contributions_refunded),2) as disbursements,
       ROUND(SUM(((contributions_ind_part + contributions_corp + contributions_other + contributions_inkind + other_receipts + transfers_in + loans_received + expenditures_refunded)
            - (expenditures + transfers_out + loans_repayed + contributions_refunded))),2) as net_raise,
       ROUND(SUM(((contributions_ind_part + contributions_corp + contributions_other + other_receipts + transfers_in + loans_received + expenditures_refunded)
            - (expenditures + transfers_out + loans_repayed + contributions_refunded))),2) as net_cash,
       average_transaction_date, earliest_transaction_date, latest_transaction_date
FROM
(SELECT filer_id, election_year, filing_abbreviation, filing_description,
COALESCE(MAX(case when sq.filing_schedule_abbreviation like "A" then sq.sum end),0) contributions_ind_part,
COALESCE(MAX(case when sq.filing_schedule_abbreviation like "B" then sq.sum end),0) contributions_corp,
COALESCE(MAX(case when sq.filing_schedule_abbreviation like "C" then sq.sum end),0) contributions_other,
COALESCE(MAX(case when sq.filing_schedule_abbreviation like "D" then sq.sum end),0) contributions_inkind,
COALESCE(MAX(case when sq.filing_schedule_abbreviation like "E" then sq.sum end),0) other_receipts,
COALESCE(MAX(case when sq.filing_schedule_abbreviation like "F" then sq.sum end),0) expenditures,
COALESCE(MAX(case when sq.filing_schedule_abbreviation like "G" then sq.sum end),0) transfers_in,
COALESCE(MAX(case when sq.filing_schedule_abbreviation like "H" then sq.sum end),0) transfers_out,
COALESCE(MAX(case when sq.filing_schedule_abbreviation like "I" then sq.sum end),0) loans_received,
COALESCE(MAX(case when sq.filing_schedule_abbreviation like "J" then sq.sum end),0) loans_repayed,
COALESCE(MAX(case when sq.filing_schedule_abbreviation like "K" then sq.sum end),0) liabilities_forgiven,
COALESCE(MAX(case when sq.filing_schedule_abbreviation like "L" then sq.sum end),0) expenditures_refunded,
COALESCE(MAX(case when sq.filing_schedule_abbreviation like "M" then sq.sum end),0) contributions_refunded,
COALESCE(MAX(case when sq.filing_schedule_abbreviation like "N" then sq.sum end),0) liabilities_outstanding,
COALESCE(MAX(case when sq.filing_schedule_abbreviation like "O" then sq.sum end),0) subcontractor_payments,
COALESCE(MAX(case when sq.filing_schedule_abbreviation like "P" then sq.sum end),0) housekeeping_receipts,
COALESCE(MAX(case when sq.filing_schedule_abbreviation like "Q" then sq.sum end),0) housekeeping_expenses,
COALESCE(MAX(case when sq.filing_schedule_abbreviation like "R" then sq.sum end),0) expense_allocation_among_candidates,
MAX(average_transaction_date) as average_transaction_date,
MIN(earliest_transaction) as earliest_transaction_date,
MAX(latest_transaction) as latest_transaction_date
from (SELECT filer_id, election_year, filing_abbreviation, filing_description, filing_schedule_abbreviation, ROUND(SUM(td.original_amount),2) as 'sum', avg(transaction_date) as 'average_transaction_date', min(transaction_date) as 'earliest_transaction', max(transaction_date) as 'latest_transaction'
    from nxsidx_ny.nys_transaction_data_child td
    group by filer_id, election_year, filing_abbreviation, filing_schedule_abbreviation) sq
group by filer_id, election_year, filing_abbreviation) pivot
group by filer_id, election_year, filing_abbreviation
order by filer_id, election_year, average_transaction_date;


ALTER TABLE import_ny.cf_disclosure_report_nodup DROP INDEX idx_cf_disclosure_report_nodup_summary;