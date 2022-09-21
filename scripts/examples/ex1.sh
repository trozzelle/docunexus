#!/usr/bin/env bash

# DON'T FORGET TO: chmod gu+x scripts/examples/ex1.sh 
# script_mysqlrun "process_name" mysql_user mysql_dc "/path/to/file.sql"
# script_pyrun "process_name" "python commandline call"

script_dir="$( dirname ${BASH_SOURCE[0]} )"
script_file="$( basename -s .sh ${BASH_SOURCE[0]} )"
script_logname="$( basename -s .sh ${BASH_SOURCE[0]} )"
source "$(dirname "${BASH_SOURCE[0]}")/../script_helper.sh"

# run the .sql file with the same name using the nxs_admin mysql user (requires conf/mysql/nxs_admin.cnf) using the import_ny schema/db
script_mysqlrun "show_users_script" nxs_admin import_ny "${script_dir}/${script_file}.sql"

# run a different sql file
script_mysqlrun "show_emails_script" nxs_admin import_ny "${script_dir}/ex1a.sql"

# run a sql block
script_mysqlrun "show_users_sql" nxs_admin import_ny "
select username 
from dcnxs_app.users;
"

# run a python function (import relative to $PYTHON_FILE_LOCATION)
script_pyrun "show_2020_elections" "from examples import ex1; ex1.elections_by_year('2020');"

script_exit

