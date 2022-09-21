#!/usr/bin/env bash
script_file="$( basename -s .sh ${BASH_SOURCE[0]} )"
script_dir="$( dirname ${BASH_SOURCE[0]} )"
script_logname="$( basename ${script_dir} )_${script_file}"
source "$(dirname "${BASH_SOURCE[0]}")/../../script_helper.sh"

script_mysqlrun "dummy_table" nxs_admin defaultdb "

DROP VIEW IF EXISTS shrd.dummy_table_v;
DROP TABLE IF EXISTS shrd.dummy_table;

"

script_exit