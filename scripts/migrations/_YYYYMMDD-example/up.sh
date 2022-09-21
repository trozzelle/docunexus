#!/usr/bin/env bash
script_file="$( basename -s .sh ${BASH_SOURCE[0]} )"
script_dir="$( dirname ${BASH_SOURCE[0]} )"
script_logname="$( basename ${script_dir} )_${script_file}"
source "$(dirname "${BASH_SOURCE[0]}")/../../script_helper.sh"

script_mysqlrun "dummy_table" nxs_admin defaultdb "

CREATE TABLE shrd.dummy_table(
  id int NOT NULL AUTO_INCREMENT,
  dummy_column varchar(255),
  PRIMARY KEY (id)
);


"
script_mysqlrun "dummy_table_v" nxs_admin defaultdb "${script_dir}/dummy_table_v.sql"

script_exit