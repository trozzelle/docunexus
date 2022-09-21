<?php
error_reporting(E_ALL & ~E_NOTICE);
ini_set('display_errors', TRUE);
ini_set('display_startup_errors', TRUE);

require_once ($_SERVER['DOCUMENT_ROOT'] . '/db.config.php');

$r = $_REQUEST;
$token = $_REQUEST['token'];
$request = (array)json_decode($r['query']);

$arr_token = check_token($_REQUEST['token']);
if (count($arr_token)) {
    die(json_encode($arr_token));
}

//Initialize
$userID = $request['userid'];
$pageLocation = $request['pagelocation'];

if (!$userID) {
    die("{error: 'No user ID provided'}");
} else {
    $userID = trim($userID);
}

if (!$pageLocation) {
    die("{error: 'No page location provided'}");
} else {
    $pageLocation = trim($pageLocation);
}

//Connect to Donor Database

$db = db_conn('@nxsidx_app');


$sql = "CALL nxsidx_app.nxsidx_get_bookmark_status(?,?);";
$stmtParams = array($userID, $pageLocation);

$db = db_conn('@nxsidx_app');

$stmt = $db->Prepare($sql);
try {
    $rs = $db->Execute($stmt, $stmtParams);
} catch (ADODB_Exception $e) {
    $db->disconnect();
    die(dbErr($e->getMessage()));
}

$db->disconnect();
$arr = $rs->GetArray();

echo json_encode($arr);

exit();
