#!/usr/bin/env bash
source /root/.profile
script_dir="$( dirname ${BASH_SOURCE[0]} )"
script_file="$( basename -s .sh ${BASH_SOURCE[0]} )"
date=$(date +"%Y-%m-%d-%H-%M-%S")
log_dir="${ATTACHED_VOLUME_LOCATION}/log/${script_dir}"
mkdir -p ${log_dir}
log_file="${log_dir}/${script_file}.${date}".log

echo "$(date +"%Y-%m-%d-%H-%M-%S") Starting..." > "${log_file}"
mysql -v -e "call dcnxs_ny.refresh_prc('refresh_history',30000,now() + INTERVAL 14400 second);" >> "${log_file}"
echo "$(date +"%Y-%m-%d-%H-%M-%S") Completed" >> "${log_file}"