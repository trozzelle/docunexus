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

// Select list of counties in NYS and joins on county committee table to identify if there are any records
// for that committee. If not, the links are disabled client-side. Lateral select gets # of records
// for county in committee table for display.
$sqlAll = 'SELECT DISTINCT nzc.county_name, nysc.county_code, nycc.id, ct.member_count
FROM nxsidx_ny.nys_zip_codes nzc
         LEFT JOIN nxsidx_ny.nys_county_committees nycc
                   ON nzc.county_name = nycc.county
         JOIN nxsidx_ny.nys_counties nysc
              ON nzc.county_name = nysc.county_name,
LATERAL (
    SELECT count(cc.county) as member_count
    FROM nxsidx_ny.nys_county_committees cc
    WHERE cc.county = nzc.county_name
        ) as ct
GROUP BY nzc.county_name
ORDER BY nzc.county_name';

$db = db_conn('@nxsidx_ny');

$conf = "SET sql_mode= ''";
$stmtconf = $db->Prepare($conf);
$db->Execute($stmtconf);

$stmtAll = $db->Prepare($sqlAll);

try {
    $rsAll = $db->Execute($stmtAll);
} catch (ADODB_Exception $e) {
    $db->disconnect();
    die(dbErr($e->getMessage()));
}

//pearErr($db, ADODB_PEAR_Error());
$arrAll = $rsAll->GetArray();
echo json_encode($arrAll);

exit();
