<?php
error_reporting(E_ALL & ~E_NOTICE);
ini_set("display_errors", 1);
//Database configuration
require_once ($_SERVER['DOCUMENT_ROOT'] . '/db.config.php');

//Check user authentication token
$arr_token = check_token($_REQUEST['token']);
if (count($arr_token)) { die(json_encode($arr_token)); }

$listid = $_REQUEST['listid'];
$userid = $_REQUEST['userid'];

if (!$listid) {
    die('{"error": "No list ID provided"}');
}
if (!$userid) {
    die('{"error": "No user ID provided"}');
}

$sql = "CALL dcnxs_ny.get_list(?,?);";
$stmtParams = array($userid, $listid);    

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