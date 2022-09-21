<?php
error_reporting(E_ALL & ~E_NOTICE);
ini_set("display_errors", 1);
require_once ($_SERVER['DOCUMENT_ROOT'] . '/db.config.php');

$userid = $_REQUEST['userid'];
$password = $_REQUEST['password'];
if (!$userid) {
    die('{"status": "error", "data": "No user ID provided."}');
}

$newpass = hash('sha512', HASH.$password);

$sql = "UPDATE dcnxs_app.users SET password = ?, reset_link_token = null, reset_expires = null WHERE userid = ?";
$db = db_conn('@dcnxs_app');

$stmtParams = array($newpass, $userid);
$stmt = $db->Prepare($sql);

try {
	$rs = $db->Execute($stmt, $stmtParams);
} catch (ADODB_Exception $e) {
	$db->disconnect();
    die(dbErr($e->getMessage()));    
}
pearErr($db, ADODB_PEAR_Error());
die('{"status": "success", "data": "Your password has been successfully updated."}');
