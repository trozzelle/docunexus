<?php
error_reporting(E_ALL & ~E_NOTICE);
ini_set("display_errors", 1);
//Database configuration
require_once ($_SERVER['DOCUMENT_ROOT'] . '/db.config.php');

//Check user authentication token
$arr_token = check_token($_REQUEST['token']);
if (count($arr_token)) { die(json_encode($arr_token)); }

$userid = $_REQUEST['userid'];

if (!$userid) {
   die('{"error": "No user ID provided"}');
}

$db = db_conn('@dcnxs_ny');
$sql = "SELECT matchid, matchfile_name FROM matches WHERE userid = ?";
$stmtParams = array($userid);

$stmt = $db->Prepare($sql);
try {
	$rs = $db->Execute($stmt, $stmtParams);
} catch (ADODB_Exception $e) {
	$db->disconnect();
    die(dbErr($e->getMessage()));
   
}
pearErr($db, ADODB_PEAR_Error());
unset($sql);

$arr = $rs->GetArray();
$db->disconnect();

echo json_encode($arr);