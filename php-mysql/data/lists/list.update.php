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
$listid = $_REQUEST['listid'];
$list_count = $_REQUEST['list_count'];
$query = $_REQUEST['query'];

if (!$userid) {
    die('{"error": "No user ID provided"}');
}

if (!$listid) {
    die('{"error": "No list ID provided"}');
}

if (!$query) {
    die('{"error": "No query provided"}');
}

$sql = "CALL dcnxs_ny.update_list(?, ?, ?, ?);";
$stmtParams = array($userid, $listid, $list_count, $query);        

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
echo json_encode($arr);