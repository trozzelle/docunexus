<?php
error_reporting(E_ALL & ~E_NOTICE);
ini_set('display_errors', TRUE);
ini_set('display_startup_errors', TRUE);

require_once ($_SERVER['DOCUMENT_ROOT'] . '/db.config.php');

$r = $_REQUEST;
$request = (array)json_decode($r['query']);

//Check user authentication token
$arr_token = check_token($_REQUEST['token']);
if (count($arr_token)) { die(json_encode($arr_token)); }

$userID = $request['userid'];
$saveID = $request['saveid'];
$saveName = $request['savename'];

$arrSql = array();
$q = '';

if (!$userID) {
    die("{error: 'No user ID provided'}");
}
if (!$saveID) {
    die("{error: 'No save ID provided'}");
}

if(!$saveName) {
    die("{error: 'No save name provided");
}
else {
    $saveName = trim($saveName);

    $arrSql['sp'][] .= "save_name = '" .$saveName."'";
}

if(count($arrSql['sp'])) {
    $q .= " SET ";
    $tmp = array();
    foreach ($arrSql['sp'] as $a) {
        $tmp[] = "sp.".$a;
    }
    $q .= implode(" AND ", $tmp);
}

$sql = 'CALL nxsidx_app.nxsidx_edit_saved_list(?,?,?)';

$db = db_conn('@nxsidx_app');

$stmt = $db->Prepare($sql);
$stmtParams = array($userID, $saveID, $saveName);

try {

    $rs = $db->Execute($stmt, $stmtParams);

    /** @TODO For some reason, this suppresses an alert in the webpage. Needs to be examined and fixed but keeping this
     * in until then.
     * */
    error_log(print_r($rs));
} catch (ADODB_Exception $e) {
    $db->disconnect();
    die(dbErr($e->getMessage()));
}

//pearErr($db, ADODB_PEAR_Error());
$db->disconnect();

echo json_encode($rs);
