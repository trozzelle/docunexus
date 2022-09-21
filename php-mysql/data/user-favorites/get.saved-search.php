<?php
error_reporting(E_ALL & ~E_NOTICE);
ini_set("display_errors", 1);
//Database configuration
require_once ($_SERVER['DOCUMENT_ROOT'] . '/db.config.php');

$r = $_REQUEST;

$request = (array)json_decode($r['query']);
$token = $_REQUEST['token'];

//Check user authentication token
$arr_token = check_token($token);
if (count($arr_token)) {
    die(json_encode($arr_token));
}


$userID = $request['userid'];
$saveID = $request['saveid'];

if(!$userID) {
	die("{error: 'No user ID provided'}");
}

if(!$saveID) {
	die("{error: 'No search ID provided'");
}

$sql = "CALL nxsidx_app.nxsidx_get_single_saved_search(?,?);";
$stmtParams = array($userID, $saveID);
$db = db_conn('@nxsidx_app');


$stmt = $db->Prepare($sql);


try {
	$rs = $db->Execute($stmt, $stmtParams);
} catch (ADODB_Exception $e) {
	$db->disconnect();
	die(dbErr($e->getMessage()));
}
//pearErr($db, ADODB_PEAR_Error());

$db->disconnect();

$arr = $rs->GetArray();

echo json_encode($arr);

exit();