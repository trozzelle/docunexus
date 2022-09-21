#!/usr/bin/env bash
target_table=${1}
refresh_type=${2}
limit=${3}
run_seconds=${4}
script_logname="ny_refresh_${target_table}"
source "$(dirname "${BASH_SOURCE[0]}")/../../script_helper.sh"

script_pyrun "refresh_${target_table}" "import data_ny_gov; data_ny_gov.refresh_target_table('${target_table}','${refresh_type}',${limit},${run_seconds});"

script_exit