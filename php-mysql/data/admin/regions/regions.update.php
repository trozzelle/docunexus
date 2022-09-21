<?php
error_reporting(E_ALL & ~E_NOTICE);
ini_set("display_errors", 1);
//Database configuration
require_once ($_SERVER['DOCUMENT_ROOT'] . '/db.config.php');

//Check user authentication token
$arr_token = check_token($_REQUEST['token']);
if (count($arr_token)) { die(json_encode($arr_token)); }

$region_id = $_REQUEST['regionid'];
$region_name = $_REQUEST['region_name'];
$action = $_REQUEST['action'];

switch($action) {
    case 'add':
        $stmtParams = array($region_name);
        $sql = "CALL dcnxs_app.add_region(?);";
    break;
    case 'update':
        $stmtParams = array($region_id, $region_name);
        $sql = "CALL dcnxs_app.update_region(?, ?);";
    break;
    case 'delete':
        $stmtParams = array($region_id);
        $sql = "CALL dcnxs_app.delete_region(?);";
    break;
    default:
        die('{"error": "Invalid region action provided"}');
    break;
}

$db = db_conn('@dcnxs_app');
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
echo json_encode($arr);