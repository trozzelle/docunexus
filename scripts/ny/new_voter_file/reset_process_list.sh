#!/usr/bin/env bash
source /root/.profile
refresh_set=${1}
script_dir="$( dirname ${BASH_SOURCE[0]} )"
script_file="$( basename -s .sh ${BASH_SOURCE[0]} )"
date=$(date +"%Y-%m-%d-%H-%M-%S")
log_dir="${ATTACHED_VOLUME_LOCATION}/log/${script_dir}"
mkdir -p ${log_dir}
log_file="${log_dir}/${date}_${script_file}_${refresh_set}".log

echo "$(date +"%Y-%m-%d-%H-%M-%S") Starting..." > "${log_file}"
mysql -v -e "call dcnxs_ny.reset_process_list_prc('refresh_${refresh_set}');" >> "${log_file}"
echo "$(date +"%Y-%m-%d-%H-%M-%S") Completed" >> "${log_file}"