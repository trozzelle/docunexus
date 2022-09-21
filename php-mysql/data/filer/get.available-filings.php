<?php
error_reporting(E_ALL & ~E_NOTICE);
ini_set('display_errors', TRUE);
ini_set('display_startup_errors', TRUE);

require_once ($_SERVER['DOCUMENT_ROOT'] . '/db.config.php');

$r = $_REQUEST;
$token = $_REQUEST['token'];
$request = (array)json_decode($r['query']);
if ($request['action'] == 'download') {
    $token = array();
    $t = json_decode($r['token']);
    $token[] = json_encode($t[0]);
}

//Check user authentication token
$arr_token = check_token($token);
if (count($arr_token)) { die(json_encode($arr_token)); }

//Initialize

$db = db_conn('@nxsidx_ny');


$sql = "SELECT DISTINCT election_year, filing_abbreviation, filing_description
FROM nys_transaction_data_summary_by_filing
ORDER BY election_year DESC";


$stmt = $db->Prepare($sql);

try {
    $rs = $db->Execute($stmt);
} catch (ADODB_Exception $e) {
    // $db->disconnect();
    die(dbErr($e->getMessage()));
}
$arr = $rs->GetArray();

echo json_encode($arr);

exit();
