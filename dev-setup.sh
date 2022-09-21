#!/usr/bin/env bash

script_logname="dev-setup"
source "$(dirname "${BASH_SOURCE[0]}")/scripts/script_helper.sh"

"$(dirname "${BASH_SOURCE[0]}")/scripts/setup.sh"

( cd ${REPO_ROOT}/php-mysql; composer update )
( cd ${REPO_ROOT}/vuejs; npm install; npm run serve ) 2>&1 &

script_exit