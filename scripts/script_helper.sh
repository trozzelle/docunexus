#!/usr/bin/env bash
source "$(dirname "${BASH_SOURCE[0]}")/../conf/config.sh"
script_sourced_by="$(caller 0)"
script_return_code=0
script_error_action="exit"
if [ "${script_logname}" = "" ]; then
	echo "ERROR: script_logname must be specified before sourcing script_helper.sh.sh"
	script_return_code=1
	exit $script_return_code
fi

script_logts=`date +%Y-%m-%d-%H-%M-%S`

script_branch=`cd ${REPO_ROOT}> /dev/null; git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`

if [ "${script_branch}" = "" ]; then
    script_branch="no-git-branch"
fi

if [ "${script_logdir}" = "" ]; then
    script_logdir="${SCRIPT_LOG_LOCATION}/${script_branch}/${script_logts}_${script_logname}"
fi

mkdir -p "${script_logdir}"
script_logts=`date +%Y-%m-%d-%H-%M-%S`
script_parent_logfile="${script_logdir}/_parent.log"

script_childname_list=
script_childpid_list=
script_pyname_list=
script_pypid_list=
script_mysqlname_list=
script_mysqlpid_list=
script_cmdname_list=
script_cmdpid_list=

# append message to log file
script_log() {
    ts=`date +%Y-%m-%d-%H-%M-%S`
	echo "${ts} $@" >> "${script_parent_logfile}"
}

# traceback functions
script_stacktrace (){
	prefix=$1
	[ "${prefix}" == "" ] && prefix="STACKTRACE"
    local i=0
    callers=$(while caller $i; do ((i++)); done)
	callers="${callers//$'\n'/,}"
	script_log "${prefix}:${callers}"
}

# exit from script
script_exit() {
	[ $# -gt 0 ] && script_log "$@"
	script_log Script "${script_logname}" exiting $script_return_code
	echo "script exited with return code $script_return_code"
	exit $script_return_code
}

# function called at the end of script_wait, jobwait, etc to determine next steps
script_waiting_complete() {
	if [ $script_return_code -gt 0 ]; then
		if [[ "${script_error_action}" == "continue" ]]; then
			script_log "Continuing despite script_return_code=$script_return_code"
		elif [[ "${script_error_action}" == "set_rc0" ]]; then
			script_log "Resetting rc from $script_return_code to 0 and exiting"
			script_return_code=0
			script_exit
		elif [[ "${script_error_action}" == "set_rc0_continue" ]]; then
			script_log "Resetting rc from $script_return_code to 0 and continuing"
			script_return_code=0
		elif [[ "${script_error_action}" == "exit" ]]; then
			script_log "Exiting because script_return_code=$script_return_code"
			script_exit
		else # "exit" is the default behavior
			script_log "Exiting because script_return_code=$script_return_code"
			script_exit
		fi
	fi
}

# start a child script
script_start() {
	childpath=$1
	childname=`echo $childpath | sed -e 's/.*\/\([^\/]*\)\.sh$/\1/'`
    ts=`date +%Y-%m-%d-%H-%M-%S`
    ("$@" > "${script_logdir}/${ts}_child_${childname}.log" ) >> "${script_parent_logfile}" 2>&1 &
	childpid=$!
	script_log Child script $childname starting, process ID $childpid
	script_stacktrace "CHILD $childname CALLED VIA"
	script_childname_list[$childpid]="$childname"
	script_childpid_list[$childpid]="$childpid"
}

# wait for completion of started child script
script_wait() {
	for pid in ${script_childpid_list[*]}; do
		wait $pid
		rcchild=$?
		if [ $rcchild -gt 0 ]; then
			script_log "ALERT: Child Script ${script_childname_list[$pid]} actual return code: ${rcchild}"
		fi
		[ $script_return_code -lt $rcchild ] && script_return_code=$rcchild
		script_log Child script ${script_childname_list[$pid]}, process ID $pid exited $rcchild
	done
	unset script_childname_list
	unset script_childpid_list
	script_waiting_complete
}
# run a child script and wait for completion
script_run() {
	script_start "$@"
	script_wait
}

# start a python call
script_pystart() {
	pyname=$1
    shift 1
    ts=`date +%Y-%m-%d-%H-%M-%S`
	(cd ${PYTHON_FILE_LOCATION}; python -c"$@" > "${script_logdir}/${ts}_python_${pyname}.log" ) >> "${script_parent_logfile}" 2>&1 &
	pypid=$!
    script_text="Python $pyname starting, process ID $pypid"
	script_stacktrace "PYTHON $pyname CALLED VIA"
	script_log "${script_text}"
	script_pyname_list[$pypid]="$pyname"
	script_pypid_list[$pypid]="$pypid"
}

# wait for completion of started python calls
script_pywait() {
	for pid in ${script_pypid_list[*]}; do
		wait $pid
		rcpy=$?
		if [ $rcpy -gt 0 ]; then
			script_log "ALERT: Python ${script_pyname_list[$pid]} actual return code: ${rcpy}"
		fi
		[ $script_return_code -lt $rcpy ] && script_return_code=$rcpy
        script_text="Python ${script_pyname_list[$pid]}, process ID $pid exited $rcpy"
		script_log "${script_text}"		
	done
	unset script_pyname_list
	unset script_pypid_list
	script_waiting_complete
}

# run a single python call to completion
script_pyrun() {
	script_pystart "$@"
	script_pywait
}


# start a mysql script
script_mysqlstart() {
	script_log "script_mysqlstart $@"
	
	ts=`date +%Y-%m-%d-%H-%M-%S`

	mysqlname=$1
    shift 1
	script_log "script_mysqlstart mysqlname=${mysqlname}"

	mysqluser=$1
    shift 1
	script_log "script_mysqlstart mysqluser=${mysqluser}"

	mysqlschemadb=$1
    shift 1
	script_log "script_mysqlstart mysqlschemadb=${mysqlschemadb}"

	if [ -f "$@" ]; then
		mysqlfile="$@"
	else
		mysqlfile="${script_logdir}/${ts}_mysql_${mysqlname}.sql"
		echo "$@" > "${mysqlfile}"
	fi

	defaults_extra_file="${REPO_ROOT}/conf/mysql/${mysqluser}.cnf"
	(mysql --defaults-extra-file="${defaults_extra_file}" "${mysqlschemadb}" -e "source ${mysqlfile}" > "${script_logdir}/${ts}_mysql_${mysqlname}.log") >> "${script_parent_logfile}" 2>&1 &
	mysqlpid=$!
    script_text="MySQL $mysqlname starting, process ID $mysqlpid"
	script_stacktrace "MYSQL $mysqlname CALLED VIA"
	script_log "${script_text}"
	script_mysqlname_list[$mysqlpid]="$mysqlname"
	script_mysqlpid_list[$mysqlpid]="$mysqlpid"
}

# wait for completion of started mysql scripts
script_mysqlwait() {
	for pid in ${script_mysqlpid_list[*]}; do
		wait $pid
		rcmysql=$?
		if [ $rcmysql -gt 0 ]; then
			script_log "ALERT: MySQL ${script_mysqlname_list[$pid]} actual return code: ${rcmysql}"
		fi
		[ $script_return_code -lt $rcmysql ] && script_return_code=$rcmysql
        script_text="MySQL ${script_mysqlname_list[$pid]}, process ID $pid exited $rcmysql"
		script_log "${script_text}"		
	done
	unset script_mysqlname_list
	unset script_mysqlpid_list
	script_waiting_complete
}

# run a single mysql script to completion
script_mysqlrun() {
	script_mysqlstart "$@"
	script_mysqlwait
}

# start a command
script_cmdstart() {
	cmdname=$1
    shift 1
    ts=`date +%Y-%m-%d-%H-%M-%S`
	($@ > "${script_logdir}/${ts}_cmd_${cmdname}.log" ) >> "${script_parent_logfile}" 2>&1 &
	cmdpid=$!
    script_text="Command $cmdname starting, process ID $cmdpid"
	script_stacktrace "COMMAND $cmdname CALLED VIA"
	script_log "${script_text}"
	script_cmdname_list[$cmdpid]="$cmdname"
	script_cmdpid_list[$cmdpid]="$cmdpid"
}

# wait for completion of started commands
script_cmdwait() {
	for pid in ${script_cmdpid_list[*]}; do
		wait $pid
		rccmd=$?
		if [ $script_return_code -gt 0 ]; then
			script_log "ALERT: Command ${script_cmdname_list[$pid]} actual return code: ${rccmd}"
		fi
		[ $script_return_code -lt $rccmd ] && script_return_code=$rccmd
        script_text="Command ${script_cmdname_list[$pid]}, process ID $pid exited $rccmd"
		script_log "${script_text}"		
	done
	unset script_cmdname_list
	unset script_cmdpid_list
	script_waiting_complete
}

# run a single command to completion
script_cmdrun() {
	script_cmdstart "$@"
	script_cmdwait
}

# trap signals and then terminate script_helper instance
script_sigterminate() {
    script_return_code=143
	script_exit Caught termination signal
}
trap script_sigterminate 15

[ ! -f "${script_parent_logfile}" ] && sleep 1 && [ ! -f "${script_parent_logfile}" ] && sleep 4
script_log Script "${script_logname}" starting, process ID $$

script_log "@: $@"
script_log "script_sourced_by: ${script_sourced_by}"
script_log "script_logname: ${script_logname}"
script_log "script_logts: ${script_logts}"
script_log "script_parent_logfile: ${script_parent_logfile}"

# defaults files
install -m 700 -d "$(dirname "${BASH_SOURCE[0]}")/../conf/mysql"

install -m 600 /dev/null "$(dirname "${BASH_SOURCE[0]}")/../conf/mysql/doadmin.cnf"
echo "[client]
host=""dcnxs-db-dev-do-user-8009313-0.b.db.ondigitalocean.com""
port=""25060""
user=""doadmin""
password=""${DB_PASS_DOADMIN}""
" > "$(dirname "${BASH_SOURCE[0]}")/../conf/mysql/doadmin.cnf"
script_log "installed $(dirname "${BASH_SOURCE[0]}")/../conf/mysql/doadmin.cnf"

install -m 600 /dev/null "$(dirname "${BASH_SOURCE[0]}")/../conf/mysql/old_admin.cnf"
echo "[client]
host=""localhost""
user=""admin""
password=""${DB_PASS_NXS_ADMIN}""
" > "$(dirname "${BASH_SOURCE[0]}")/../conf/mysql/old_admin.cnf"
script_log "installed $(dirname "${BASH_SOURCE[0]}")/../conf/mysql/old_admin.cnf"

install -m 600 /dev/null "$(dirname "${BASH_SOURCE[0]}")/../conf/mysql/nxs_admin.cnf"
echo "[client]
host=""dcnxs-db-dev-do-user-8009313-0.b.db.ondigitalocean.com""
port=""25060""
user=""nxs_admin""
password=""${DB_PASS_NXS_ADMIN}""
" > "$(dirname "${BASH_SOURCE[0]}")/../conf/mysql/nxs_admin.cnf"
script_log "installed $(dirname "${BASH_SOURCE[0]}")/../conf/mysql/nxs_admin.cnf"

install -m 600 /dev/null "$(dirname "${BASH_SOURCE[0]}")/../conf/mysql/nxs_app.cnf"
echo "[client]
host=""dcnxs-db-dev-do-user-8009313-0.b.db.ondigitalocean.com""
port=""25060""
user=""nxs_app""
password=""${DB_PASS_NXS_APP}""
" > "$(dirname "${BASH_SOURCE[0]}")/../conf/mysql/nxs_app.cnf"
script_log "installed $(dirname "${BASH_SOURCE[0]}")/../conf/mysql/nxs_app.cnf"

# The next line updates PATH for the Google Cloud SDK.
#if [ -f '/usr/local/bin/google-cloud-sdk/path.bash.inc' ]; then . '/usr/local/bin/google-cloud-sdk/path.bash.inc'  >> "${script_parent_logfile}"; fi

# The next line enables shell command completion for gcloud.
#if [ -f '/usr/local/bin/google-cloud-sdk/completion.bash.inc' ]; then . '/usr/local/bin/google-cloud-sdk/completion.bash.inc' >> "${script_parent_logfile}"; fi

#gcloud auth activate-service-account digitalocean@docunexus.iam.gserviceaccount.com --key-file="$(dirname "${BASH_SOURCE[0]}")/../conf/gsutil_auth.json"  >> "${script_parent_logfile}"


script_log "config complete"