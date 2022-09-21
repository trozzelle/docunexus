<?php
error_reporting(E_ALL & ~E_NOTICE);
ini_set("display_errors", 1);
//Database configuration
require_once ($_SERVER['DOCUMENT_ROOT'] . '/db.config.php');

//Check user authentication token
$arr_token = check_token($_REQUEST['token']);
if (count($arr_token)) { die(json_encode($arr_token)); }

$sql = "SELECT r.rightsid, r.rights_name, r.can_delete FROM dcnxs_app.rights r ORDER BY r.rightsid";

$db = db_conn('@dcnxs_app');
$stmt = $db->Prepare($sql);
try {
	$rs = $db->Execute($stmt);
} catch (ADODB_Exception $e) {
	$db->disconnect();
    die(dbErr($e->getMessage()));    
}
pearErr($db, ADODB_PEAR_Error());
$db->disconnect();
$arr = $rs->GetArray();
echo json_encode($arr);