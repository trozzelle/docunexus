<?php
error_reporting(E_ALL & ~E_NOTICE);
ini_set("display_errors", 1);
require_once ($_SERVER['DOCUMENT_ROOT'] . '/db.config.php');

$token = $_REQUEST['token'];

$sql = "SELECT email, display_name, username, userid, reset_expires FROM dcnxs_app.users WHERE reset_link_token = ?";
$db = db_conn('@dcnxs_app');

$stmtParams = array($token);
$stmt = $db->Prepare($sql);

try {
	$rs = $db->Execute($stmt, $stmtParams);
} catch (ADODB_Exception $e) {
	$db->disconnect();
    die(dbErr($e->getMessage()));    
}
pearErr($db, ADODB_PEAR_Error());
$db->disconnect();
$arr = $rs->GetArray();

if (count($arr) == 0) {
    die('{"status": "error", "data": "The password reset token does not exist."}');
}

$dtFormat = mktime(date("H"), date("i"), date("s"), date("m") ,date("d"), date("Y"));
$dt = date($dtFormat);

if ($dt < $arr[0]['reset_expires']) {
    echo json_encode($arr);
} else {
    die('{"status": "error", "data": "This password reset request has expired."}');
}