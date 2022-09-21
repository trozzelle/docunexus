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
$filerID = $request['filerid'];

if ($filerID) {
    $filerID = trim($filerID);
}
else {
    die("{error: 'No Filer ID provided'}");
}

$sqlAll = 'CALL nxsidx_ny.nxsidx_get_filer_summary_by_schedule(?)';
$stmtParams = array($filerID);


$db = db_conn('@nxsidx_ny');

$stmtAll = $db->Prepare($sqlAll);

try {
    $rsAll = $db->Execute($stmtAll, $stmtParams);
} catch (ADODB_Exception $e) {
    $db->disconnect();
    die(dbErr($e->getMessage()));
}

//pearErr($db, ADODB_PEAR_Error());
$arrAll = $rsAll->GetArray();
echo json_encode($arrAll);

exit();
