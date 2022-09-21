#!/usr/bin/env bash
target_table=${1}
script_logname="ny_reset_${target_table}"
source "$(dirname "${BASH_SOURCE[0]}")/../../script_helper.sh"

script_pyrun "reset_${target_table}" "import data_ny_gov; data_ny_gov.reset_target_table('${target_table}');"

script_exit