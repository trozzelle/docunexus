<?php
error_reporting(E_ALL & ~E_NOTICE);
ini_set('display_errors', TRUE);
ini_set('display_startup_errors', TRUE);

require_once($_SERVER['DOCUMENT_ROOT'] . '/db.config.php');

$r = $_REQUEST;
$request = (array)json_decode($r['query']);

//Check user authentication token
$arr_token = check_token($_REQUEST['token']);
if (count($arr_token)) { die(json_encode($arr_token)); }

$userid = $request['userid'];
$saveid = $request['saveid'];

if (!$userid) {
    die("{error: 'No user ID provided'}");
}
if (!$saveid) {
    die("{error: 'No match ID provided'}");
}

$sql = "CALL nxsidx_app.nxsidx_delete_saved_search(?, ?);";


$db = db_conn('@nxsidx_app');

$stmt = $db->Prepare($sql);
$stmtParams = array($userid, $saveid);

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
