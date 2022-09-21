#!/usr/bin/env bash
target_table=${1}
script_logname="ny_download_${target_table}"
source "$(dirname "${BASH_SOURCE[0]}")/../../script_helper.sh"

script_pyrun "download_${target_table}_csv" "import data_ny_gov; data_ny_gov.download_target_csv('${target_table}');"

script_exit