#!/usr/bin/env bash
script_file="$( basename -s .sh ${BASH_SOURCE[0]} )"
script_dir="$( dirname ${BASH_SOURCE[0]} )"
script_logname="$( basename ${script_dir} )_${script_file}"
source "$(dirname "${BASH_SOURCE[0]}")/../../script_helper.sh"

#NOPE for this time, too much built
#script_mysqlrun "import_ny_db" nxs_admin defaultdb "
#
#DROP DATABASE import_ny;
#
#"

script_exit