<?php
error_reporting(E_ALL & ~E_NOTICE);
ini_set("display_errors", 1);
//Database configuration
require_once ($_SERVER['DOCUMENT_ROOT'] . '/db.config.php');

//Check user authentication token
$t = json_decode($_REQUEST['token']);
$token[] = json_encode($t[0]);  
$arr_token = check_token($token);
if (count($arr_token)) { die(json_encode($arr_token)); }

$userid = $_REQUEST['userid'];
$list_name = $_REQUEST['list_name'];
$list_count = $_REQUEST['list_count'];
$source = $_REQUEST['source'];
$query = $_REQUEST['query'];

if (!$userid) {
    die('{"error": "No user ID provided"}');
}

if (!$list_name) {
    die('{"error": "No list name provided"}');
}

if (!$source) {
    die('{"error": "No query source provided"}');
}

if (!$query) {
    die('{"error": "No query provided"}');
}

$sql = "CALL dcnxs_ny.save_list(?, ?, ?, ?, ?);";
$stmtParams = array($userid, $list_name, $list_count, $source, $query);        

$db = db_conn('@dcnxs_ny');
$stmt = $db->Prepare($sql);
try {
	$rs = $db->Execute($stmt, $stmtParams);
} catch (ADODB_Exception $e) {
	$db->disconnect();
    die(dbErr($e->getMessage()));    
}
pearErr($db, ADODB_PEAR_Error());
$arr = $rs->GetArray();
if ($arr[0]['err']) {
    die('{"error": "'.$arr[0]['err'].'"}');
}

echo json_encode($arr);