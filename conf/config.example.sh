#!/usr/bin/env bash

# config.example.sh is the example file with XXXXXXXXXXXXXXXXXX in place of secrets
# config.sh is the real file with real secrets instead of XXXXXXXXXXXXXXXXXX

# config.example.sh is committed to the repository
# config.sh is NOT commited to the repository and should be listed in the .gitignore file

umask 002
export ATTACHED_VOLUME_LOCATION="/mnt/volume_nyc3_01"
export REPO_ROOT="/path/to/repo/root"  # /var/www/dev.docunexus.net OR /var/www/prd.docunexus.net OR /home/user/www/user.docunexus.net
export WEB_USER="XXXXXXXXXXXXXXXXXX"  #www-data
export WEB_GROUP="www-data"

export SCRIPT_LOG_LOCATION="${ATTACHED_VOLUME_LOCATION}/log"
export MYSQL_FILES_LOCATION="${ATTACHED_VOLUME_LOCATION}/var/lib/mysql-files"

export PYTHON_FILE_LOCATION="${REPO_ROOT}/python-mysql"

export GSUTIL_EXE=/usr/local/bin/google-cloud-sdk/bin/gsutil

export DB_PASS_DOADMIN="XXXXXXXXXXXXXXXXXX"
export DB_PASS_NXS_ADMIN="XXXXXXXXXXXXXXXXXX"
export DB_PASS_NXS_APP="XXXXXXXXXXXXXXXXXX"
