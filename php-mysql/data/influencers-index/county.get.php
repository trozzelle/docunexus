<?php
error_reporting(E_ALL & ~E_NOTICE);
ini_set('display_errors', TRUE); 
ini_set('display_startup_errors', TRUE); 

require_once ($_SERVER['DOCUMENT_ROOT'] . '/db.config.php');
$r = $_REQUEST;
$token = $_REQUEST['token'];
$request = (array)json_decode($r['query']);

//Check user authentication token
$arr_token = check_token($token);
if (count($arr_token)) { die(json_encode($arr_token)); }

// Initialize
$county = $request['county'];

// Select a list of NYS counties joined with a second table of zip-code level data that has Lat and Long.
// This is only for development and should be properly merged and normalized.
$sqlAll = "SELECT *
FROM nxsidx_ny.nys_counties ny
WHERE ny.county_name LIKE ?";


$db = db_conn('@nxsidx_ny');

$conf = "SET sql_mode= ''";
$stmtconf = $db->Prepare($conf);
$db->Execute($stmtconf);

$stmtAll = $db->Prepare($sqlAll);
$stmtParam = array($county);
try {
    $rsAll = $db->Execute($stmtAll, $stmtParam);
} catch (ADODB_Exception $e) {
    $db->disconnect();
    die(dbErr($e->getMessage()));
}


//pearErr($db, ADODB_PEAR_Error());
$arrAll = $rsAll->GetArray();
echo json_encode($arrAll);


exit();
