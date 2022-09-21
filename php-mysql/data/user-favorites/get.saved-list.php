<?php
error_reporting(E_ALL & ~E_NOTICE);
ini_set("display_errors", 1);

//Database configuration
require_once($_SERVER['DOCUMENT_ROOT'] . '/../../conf/db.config.php');

$r = $_REQUEST;
$request = (array)json_decode($r['query']);

//Check user authentication token
$arr_token = check_token($_REQUEST['token']);
if (count($arr_token)) {
    die(json_encode($arr_token));
}

$userID = $request['userid'];
$saveID = $request['saveid'];

if(!$userID) {
    die("{error: 'No user ID provided'}");
}

if(!$saveID) {
    die("{error: 'No save ID provided'");
}

$savedListMetaStmt = "SELECT * FROM nxsidx_app.saved_lists WHERE userid = ? AND saveid = ?";
$savedListParams = array($userID, $saveID);

$db = db_conn('@nxsidx_app');
$savedListMetaStmt = $db->Prepare($savedListMetaStmt);

try {
    $rsMeta = $db->Execute($savedListMetaStmt, $savedListParams);
} catch (ADODB_Exception $e) {
    $db->disconnect();
    die(dbErr($e->getMessage()));
}

$arrMeta = $rsMeta->GetArray();

$savedListStmt = "SELECT * FROM nxsidx_user_lists." . $userID . "_saved_lists WHERE saveid = ?";
$savedListParams = array($saveID);
$db = db_conn('@nxsidx_app');

$savedListStmt = $db->Prepare($savedListStmt);


try {
    $rsList = $db->Execute($savedListStmt, $savedListParams);
} catch (ADODB_Exception $e) {
    $db->disconnect();
    die(dbErr($e->getMessage()));
}
//pearErr($db, ADODB_PEAR_Error());

$db->disconnect();

$arrList = $rsList->GetArray();

$arr = array($arrMeta,$arrList);

echo json_encode($arr);