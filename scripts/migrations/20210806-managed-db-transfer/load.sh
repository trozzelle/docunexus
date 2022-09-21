#!/usr/bin/env bash
script_file="$( basename -s .sh ${BASH_SOURCE[0]} )"
script_dir="$( dirname ${BASH_SOURCE[0]} )"
script_logname="$( basename ${script_dir} )_${script_file}"
source "$(dirname "${BASH_SOURCE[0]}")/../../script_helper.sh"

#first run
#mysqldump --defaults-extra-file="${REPO_ROOT}/conf/mysql/old_admin.cnf" \
#--compact --no-create-info --no-create-db --extended-insert --disable-keys \
#--databases shrd dcnxs_app dcnxs_ny nxsidx_app nxsidx_ny nxsidx_user_lists \
#| mysql --defaults-extra-file="${REPO_ROOT}/conf/mysql/doadmin.cnf" -D defaultdb

#second run
script_run "${script_dir}/mysqldump2.sh"

script_exit