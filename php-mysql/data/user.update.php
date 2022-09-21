<?php
error_reporting(E_ALL & ~E_NOTICE);
ini_set("display_errors", 1);
//Database configuration
require_once ($_SERVER['DOCUMENT_ROOT'] . '/db.config.php');
require_once ($_SERVER['DOCUMENT_ROOT'] . '/functions.php');

//Check user authentication token
$arr_token = check_token($_REQUEST['token']);
if (count($arr_token)) { die(json_encode($arr_token)); }

$userid = $_REQUEST['userid'];
$email = $_REQUEST['email'];
$password = $_REQUEST['password'];
$display_name = $_REQUEST['display_name'];
$username = $_REQUEST['username'];

if (!$userid) {
    die('{"error": "No user ID provided"}');
}

if (!$email) {
    die('{"error": "No email provided"}');
}

if (!$display_name) {
    die('{"error": "No display name provided"}');
}

if (!$username) {
    die('{"error": "No username provided"}');
}

if ($password > '') {
    $password = hash('sha512', HASH.$password);
} else {
    $password = '';
}

$sql = "CALL dcnxs_app.update_user(?,?,?,?,?);";

$db = db_conn('@dcnxs_app');

$stmtParams = array($userid, $email, $password, $display_name, $username);
$stmt = $db->Prepare($sql);
try {
	$rs = $db->Execute($stmt, $stmtParams);
} catch (ADODB_Exception $e) {
	$db->disconnect();
    die(dbErr($e->getMessage()));    
}
pearErr($db, ADODB_PEAR_Error());
$arr = $rs->GetArray();
if ($arr[0]['warning']) {
    die('{"warning": "'.$arr[0]['warning'].'"}');
} else {
    $expire = time()+(3600*12);		
    $arr_out = formatUserData($arr);
	setcookie('docunexus-user', $arr_out, $expire, '/');	
    die($arr_out);
}