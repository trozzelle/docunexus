#!/usr/bin/env bash
script_file="$( basename -s .sh ${BASH_SOURCE[0]} )"
script_dir="$( dirname ${BASH_SOURCE[0]} )"
script_logname="$( basename ${script_dir} )_${script_file}"
source "$(dirname "${BASH_SOURCE[0]}")/../../script_helper.sh"

script_mysqlrun "create_dbs" doadmin defaultdb "

CREATE DATABASE IF NOT EXISTS shrd;
CREATE DATABASE IF NOT EXISTS dcnxs_app;
CREATE DATABASE IF NOT EXISTS dcnxs_ny;
CREATE DATABASE IF NOT EXISTS dcnxs_ugc;
CREATE DATABASE IF NOT EXISTS nxsidx_app;
CREATE DATABASE IF NOT EXISTS nxsidx_ny;
CREATE DATABASE IF NOT EXISTS nxsidx_ugc;
CREATE DATABASE IF NOT EXISTS nxsidx_user_lists;

"
script_mysqlrun "users" doadmin defaultdb "

CREATE USER 'nxs_admin'@'%' IDENTIFIED BY '${DB_PASS_NXS_ADMIN}'
REQUIRE NONE PASSWORD EXPIRE DEFAULT ACCOUNT UNLOCK PASSWORD HISTORY DEFAULT PASSWORD REUSE INTERVAL DEFAULT PASSWORD REQUIRE CURRENT DEFAULT;

CREATE USER 'nxs_app'@'%' IDENTIFIED BY '${DB_PASS_NXS_APP}' 
REQUIRE NONE PASSWORD EXPIRE DEFAULT ACCOUNT UNLOCK PASSWORD HISTORY DEFAULT PASSWORD REUSE INTERVAL DEFAULT PASSWORD REQUIRE CURRENT DEFAULT;

"

script_mysqlrun "grants" doadmin defaultdb "${script_dir}/grants.sql"

script_mysqlrun "objects" nxs_admin defaultdb "${script_dir}/objects.sql"

script_exit