#!/usr/bin/env bash
script_file="$( basename -s .sh ${BASH_SOURCE[0]} )"
script_dir="$( dirname ${BASH_SOURCE[0]} )"
script_logname="$( basename ${script_dir} )_${script_file}"
source "$(dirname "${BASH_SOURCE[0]}")/../../script_helper.sh"

mysqldump --defaults-extra-file="${REPO_ROOT}/conf/mysql/old_admin.cnf" \
--compact --no-create-info --no-create-db --extended-insert --disable-keys \
--ignore-table=nxsidx_ny.nys_transaction_data_filers_cash_on_hand \
--ignore-table=dcnxs_ny.voter_history \
--ignore-table=dcnxs_ny.voter_history \
--ignore-table=dcnxs_ny.process_list \
--ignore-table=dcnxs_ny.voter_data \
--ignore-table=dcnxs_ny.voter_full_name \
--ignore-table=dcnxs_ny.voter_city \
--ignore-table=dcnxs_ny.voter_last_name \
--ignore-table=dcnxs_ny.voter_first_name \
--ignore-table=dcnxs_ny.voter_name_part \
--ignore-table=dcnxs_ny.nys_dem \
--ignore-table=dcnxs_ny.voter_mailing_address \
--ignore-table=dcnxs_ny.voter_email \
--ignore-table=dcnxs_ny.match_data \
--ignore-table=dcnxs_ny.process_queue \
--ignore-table=dcnxs_ny.match_potentials \
--ignore-table=nxsidx_ny.nys_filer_data_geo \
--ignore-table=nxsidx_ny.nys_filer_data_previous_id \
--ignore-table=dcnxs_ny.test_match_data \
--ignore-table=nxsidx_ny.nys_filer_map \
--ignore-table=dcnxs_ny.unmatched \
--ignore-table=nxsidx_ny.nys_county_committees \
--ignore-table=dcnxs_ny.elections \
--ignore-table=dcnxs_ny.union_match_data \
--ignore-table=dcnxs_ny.match_test \
--ignore-table=dcnxs_ny.assembly_rep \
--ignore-table=nxsidx_ny.nys_filer_offices \
--ignore-table=dcnxs_ny.senate_rep \
--ignore-table=dcnxs_ny.nys_counties \
--ignore-table=dcnxs_ny.congressional_rep \
--ignore-table=nxsidx_ny.nys_committee_types \
--ignore-table=dcnxs_ny.enrollment \
--ignore-table=dcnxs_ny.matches \
--ignore-table=dcnxs_app.users \
--ignore-table=nxsidx_app.saved_pages \
--ignore-table=dcnxs_app.rights \
--ignore-table=dcnxs_app.user_regions \
--ignore-table=nxsidx_app.saved_lists \
--ignore-table=nxsidx_app.saved_searches \
--ignore-table=dcnxs_app.group_regions \
--ignore-table=dcnxs_app.regions \
--ignore-table=dcnxs_app.user_groups \
--ignore-table=dcnxs_app.groups \
--ignore-table=shrd.api_get_position \
--ignore-table=shrd.dim_date \
--ignore-table=shrd.dim_int \
--databases shrd dcnxs_app dcnxs_ny nxsidx_app nxsidx_ny nxsidx_user_lists \
| mysql --defaults-extra-file="${REPO_ROOT}/conf/mysql/doadmin.cnf" -D defaultdb

script_exit