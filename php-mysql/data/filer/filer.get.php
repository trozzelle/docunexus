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

// if ($filerID > '') {
//     $filerID = trim($filerID);
// }
// else {
// }

//$sqlAll = "SELECT *, count(*) as record_count FROM nxsidx_ny.nys_filer_data fd
//    JOIN nxsidx_ny.nys_filer_data_previous_id pd
//    ON (fd.filer_id = pd.filer_id)
//    WHERE fd.filer_id = ?";

$sqlAll = "SELECT fd.filer_id AS filer_id, fd.filer_name AS committee_name, fd.compliance_type AS compliance_type,
       fd.filer_type AS filer_type, fd.filer_status AS filer_status, fd.committee_type AS committee_type,
       fd.office_desc AS committee_office, fd.district AS committee_district, fd.county_desc AS committee_county,
       fd.municipality_desc AS committee_municipality, fd.treasurer_first_name AS treasurer_first_name,
       fd.treasurer_middle_name AS treasurer_middle_name, fd.treasurer_last_name AS treasurer_last_name,
       fd.treasurer_address AS treasurer_address, fd.treasurer_city AS treasurer_city,
       fd.treasurer_state AS treasurer_state, fd.treasurer_zip AS treasurer_zip, fd2.filer_id AS candidate_id,
       fd2.filer_name AS candidate_name, fd2.compliance_type AS compliance_type, fd2.filer_type AS filer_type,
       fd2.filer_status AS filer_status, fd2.committee_type AS committee_Type, fd2.office_desc AS candidate_office,
       fd2.district AS candidate_district, fd2.county_desc AS candidate_county,
       fd2.municipality_desc AS candidate_municipality, fd2.treasurer_first_name AS representative_fname,
       fd2.treasurer_middle_name AS representative_mname, fd2.treasurer_last_name AS representative_lname,
       fd2.treasurer_address AS committee_address, fd2.treasurer_city AS committee_city,
       fd2.treasurer_state AS committee_state, fd2.treasurer_zip AS committee_zip
FROM nxsidx_ny.nys_filer_data fd
         JOIN nxsidx_ny.nys_filer_data_previous_id pd
              ON (fd.filer_id = pd.filer_id)
         LEFT JOIN (SELECT committee_id AS filer_key, candidate_id AS filer_value
                    FROM nys_filer_map fd1
                    UNION ALL
                    SELECT candidate_id AS filer_key, committee_id AS filer_value
                    FROM nys_filer_map fd2) fmap ON fd.filer_id = fmap.filer_key
         LEFT JOIN nys_filer_data fd2 ON fd2.filer_id = fmap.filer_value
         WHERE fd.filer_id = ?";

$db = db_conn('@nxsidx_ny');

$conf = "SET sql_mode= ''";
$stmtconf = $db->Prepare($conf);
$db->Execute($stmtconf);

$stmtParams = array($filerID);

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
