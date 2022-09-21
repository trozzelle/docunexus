#!/usr/bin/env bash
script_file="$( basename -s .sh ${BASH_SOURCE[0]} )"
script_dir="$( dirname ${BASH_SOURCE[0]} )"
script_logname="$( basename ${script_dir} )_${script_file}"
source "$(dirname "${BASH_SOURCE[0]}")/../../script_helper.sh"

script_cmdrun "pandas" "pip install pandas"
script_cmdrun "sqlalchemy" "pip install sqlalchemy"
script_cmdrun "PyMySQL" "pip install PyMySQL"

script_cmdrun "fix1" "sudo rm -f /usr/share/keyrings/cloud.google.gpg"
script_cmdrun "fix2" "sudo rm -f /usr/share/keyrings/cloud.google.gpg~"
script_cmdrun "fix3" "sudo rm -f /etc/apt/sources.list.d/google-cloud-sdk.list"
script_cmdrun "mysqlclient-deps" "sudo apt-get install python3-dev default-libmysqlclient-dev build-essential"
script_cmdrun "mysqlclient" "pip install mysqlclient"

script_exit