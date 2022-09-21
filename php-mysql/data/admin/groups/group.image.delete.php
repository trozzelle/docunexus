<?php
error_reporting(E_ALL & ~E_NOTICE);
ini_set("display_errors", 1);
//Database configuration
require_once ($_SERVER['DOCUMENT_ROOT'] . '/db.config.php');
//Check user authentication token
$arr_token = check_token($_REQUEST['token']);
if (count($arr_token)) { die(json_encode($arr_token)); }

$groupid = $_REQUEST['groupid'];

$stmtParams = array($groupid);
$sql = "UPDATE dcnxs_app.groups SET group_image = NULL WHERE groupid = ?";

$db = db_conn('@dcnxs_app');
$stmt = $db->Prepare($sql);
try {
	$db->Execute($stmt, $stmtParams);
} catch (ADODB_Exception $e) {
	$db->disconnect();
    die(dbErr($e->getMessage()));    
}
pearErr($db, ADODB_PEAR_Error());
$db->disconnect();