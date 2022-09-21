#!/usr/bin/env bash
script_file="$( basename -s .sh ${BASH_SOURCE[0]} )"
script_dir="$( dirname ${BASH_SOURCE[0]} )"
script_logname="$( basename ${script_dir} )_${script_file}"
source "$(dirname "${BASH_SOURCE[0]}")/../../script_helper.sh"

script_mysqlrun "users" doadmin defaultdb "

DROP USER IF EXISTS nxs_admin;
DROP USER IF EXISTS nxs_app;

"
script_mysqlrun "create_dbs" doadmin defaultdb "

DROP DATABASE IF EXISTS shrd;
DROP DATABASE IF EXISTS dcnxs_app;
DROP DATABASE IF EXISTS dcnxs_ny;
DROP DATABASE IF EXISTS dcnxs_ugc;
DROP DATABASE IF EXISTS nxsidx_app;
DROP DATABASE IF EXISTS nxsidx_ny;
DROP DATABASE IF EXISTS nxsidx_ugc;
DROP DATABASE IF EXISTS nxsidx_user_lists;

"

script_exit