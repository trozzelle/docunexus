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
if [[ "${refresh_set}" == "residence_address" ]] || [[ "${refresh_set}" == "mailing_address" ]] || [[ "${refresh_set}" == "previous_address" ]]; then
    cd /var/www/prd.docunexus.net/python-mysql >> "${log_file}"
    python3 -c"import dcnxs_scourgify_db; dcnxs_scourgify_db.refresh_db('refresh_${refresh_set}',1000,14400);" >> "${log_file}"
else
    mysql -v -e "call dcnxs_ny.refresh_prc('refresh_${refresh_set}',30000,now() + INTERVAL 14400 second);" >> "${log_file}"
fi

echo "$(date +"%Y-%m-%d-%H-%M-%S") Completed" >> "${log_file}"
