#!/usr/bin/env bash
target_table=${1}
script_logname="ny_load_${target_table}_csv"
source "$(dirname "${BASH_SOURCE[0]}")/../../script_helper.sh"

script_pyrun "load_${target_table}_csv" "import data_ny_gov; data_ny_gov.load_target_csv('${target_table}');"

script_exit