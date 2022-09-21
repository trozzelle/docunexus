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

$county = $request['county'];

//Check user authentication token
$arr_token = check_token($token);
if (count($arr_token)) { die(json_encode($arr_token)); }

// Select only the data that is going to be display. This selects only the obscured data, so the unobscured data isn't
// client-side. Next step will be to run different queries based on user's UID.

$sqlAll = "SELECT county,	first_name,	last_name,	address,	address_2,	address_city,	address_state,	address_zip,	affiliation, nxsidx_ny.nxsidx_obscure_email(email) AS email_obs,
       nxsidx_ny.nxsidx_obscure_phone_number(phone_number) AS phone_number_obs
FROM nxsidx_ny.nys_county_committees
WHERE county LIKE ?
AND LENGTH(first_name) > 0";

$db = db_conn('@nxsidx_ny');

$stmtAll = $db->Prepare($sqlAll);
$stmtParams = array($county);
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
