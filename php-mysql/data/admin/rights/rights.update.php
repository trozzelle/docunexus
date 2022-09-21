<?php
error_reporting(E_ALL & ~E_NOTICE);
ini_set("display_errors", 1);
//Database configuration
require_once ($_SERVER['DOCUMENT_ROOT'] . '/db.config.php');

//Check user authentication token
$arr_token = check_token($_REQUEST['token']);
if (count($arr_token)) { die(json_encode($arr_token)); }

$rightsid = $_REQUEST['rightsid'];
$rights_name = $_REQUEST['rights_name'];
$action = $_REQUEST['action'];

switch($action) {
    case 'add':
        $stmtparams = array($rights_name);
        $sql = "CALL dcnxs_app.add_rights(?);";
    break;
    case 'update':
        $stmtparams = array($rightsid, $rights_name);
        $sql = "CALL dcnxs_app.update_rights(?, ?);";
    break;
    case 'delete':
        $stmtparams = array($rightsid);
        $sql = "CALL dcnxs_app.delete_rights(?);";
    break;
    default:
        die('{"error": "Invalid rights action provided"}');
    break;
}

$db = db_conn('@dcnxs_app');
$stmt = $db->Prepare($sql);
try {
    $rs = $db->Execute($stmt, $stmtparams);
} catch (ADODB_Exception $e) {
    $db->disconnect();
    die(dbErr($e->getMessage()));  
}
pearErr($db, ADODB_PEAR_Error());
$db->disconnect();
$arr = $rs->GetArray();
echo json_encode($arr);