#!/usr/bin/env bash

gs="gs://dcnxs_etl/ny/2020_08/ny_202008_final.csv"
load_path="/mnt/volume_nyc3_01/var/lib/mysql-files/webapp/import_ny"
load_file="voter.csv"

script_logname="download_nys_voter_file"
source "$(dirname "${BASH_SOURCE[0]}")/../../script_helper.sh"

script_cmdrun "get_file" ${GSUTIL_EXE} cp ${gs} ${load_path}/${load_file}

script_cmdrun "header_row"  head --lines=3 ${load_path}/${load_file}  

echo "COLUMN COUNT: " >> "${script_parent_logfile}"
head -1 ${load_path}/${load_file} | sed 's/[^,]//g' | wc -c >> "${script_parent_logfile}"

script_cmdrun "line_count"  wc -l ${load_path}/${load_file} 

script_cmdrun "line_endings"  file -k ${load_path}/${load_file} 

script_exit
