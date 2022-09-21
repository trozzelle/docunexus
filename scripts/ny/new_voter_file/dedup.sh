#!/usr/bin/env bash
script_dir="$( dirname ${BASH_SOURCE[0]} )"
script_file="$( basename -s .sh ${BASH_SOURCE[0]} )"
script_logname="$( basename -s .sh ${BASH_SOURCE[0]} )"
source "$(dirname "${BASH_SOURCE[0]}")/../../script_helper.sh"

script_mysqlrun "${script_dir}/${script_file}".sql

script_exit