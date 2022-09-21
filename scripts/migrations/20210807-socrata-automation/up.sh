#!/usr/bin/env bash
script_file="$( basename -s .sh ${BASH_SOURCE[0]} )"
script_dir="$( dirname ${BASH_SOURCE[0]} )"
script_logname="$( basename ${script_dir} )_${script_file}"
source "$(dirname "${BASH_SOURCE[0]}")/../../script_helper.sh"

script_mysqlrun "import_ny_db" nxs_admin defaultdb "

CREATE DATABASE IF NOT EXISTS import_ny;

"


script_mysqlrun "nxsidx_ny_views" nxs_admin nxsidx_ny "

create view nxsidx_ny.nys_filer_data
as select * from import_ny.cf_filer_csv;

create view nxsidx_ny.nys_transaction_data_child
as select * from import_ny.cf_disclosure_report_csv;

"

script_exit