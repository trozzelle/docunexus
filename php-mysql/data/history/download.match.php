<?php 
ini_set('memory_limit', '768M');
ini_set('max_execution_time', 6000);
error_reporting(E_ALL & ~E_NOTICE);
ini_set('display_errors', TRUE); 
ini_set('display_startup_errors', TRUE); 

require_once ($_SERVER['DOCUMENT_ROOT'] . '/db.config.php');

//Check user authentication token
$t = json_decode($_REQUEST['token']);
$token[] = json_encode($t[0]);  
$arr_token = check_token($token);
if (count($arr_token)) { die(json_encode($arr_token)); }

$userid = $_REQUEST['userid'];
$matchid = $_REQUEST['matchid'];

if (!$userid) {
    die("{error: 'No user ID provided'}");
}
if (!$matchid) {
    die("{error: 'No match ID provided'}");
}   

$sql = "SELECT matchfile_name, matchtable FROM dcnxs_ny.matches WHERE userid = ? AND matchid = ?";
$stmtParams = array($userid, $matchid);


$db = db_conn('@dcnxs_ny');

$gb = "SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''))";
$stmtgb = $db->Prepare($gb);
$db->Execute($stmtgb);

try {
    $stmt = $db->Prepare($sql);
    $rs = $db->Execute($stmt, $stmtParams);
    $arr = $rs->GetArray();
} catch (ADODB_Exception $e) {
    $db->disconnect();
    die(dbErr($e->getMessage()));
}
pearErr($db, ADODB_PEAR_Error());


$matchtable = $arr[0]['matchtable'];
$t = explode(".", $matchtable);
$schema = $t[0];
$table = $t[1];
$filename = $arr[0]['matchfile_name'];

unset($rs);
unset($arr);
unset($stmtParams);

$stmtParams = array($schema, $table);

$sqlcols = "SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA=? AND TABLE_NAME=? ORDER BY ordinal_position";

try {
    $rscols = $db->Execute($sqlcols, $stmtParams);
} catch (ADODB_Exception $e) {
    $db->disconnect();
    die(dbErr($e->getMessage()));
}
pearErr($db, ADODB_PEAR_Error());
unset($sqlcols);
$arr_cols = $rscols->GetArray(); 

foreach ($arr_cols as $c) {
    switch ($c['COLUMN_NAME']) {
        case 'queueid':
        case 'nys_voter_id':
        break;
        default:
            $cols[] = "mf.`".$c['COLUMN_NAME']."`";
        break;        
    }
}

unset($stmtParams);
$stmtParams = array($userid, $matchid);

$sqldata = "SELECT ".implode(',',$cols).", ";
$sqldata .= "md.queueid,
vd.nys_voter_id,
vd.first_name,
vd.last_name,
vd.name_suffix, 
vd.residence_num, 
vd.residence_halfnum, 
vd.residence_aptnum, 
vd.residence_pre_street_dir, 
vd.residence_street_name, 
vd.residence_post_street_dir, 
vd.residence_city, 
vd.residence_zip, 
vd.residence_zip_4, 
vd.mailing_address_1, 
vd.mailing_address_2, 
vd.mailing_address_3, 
vd.mailing_address_4, 
vd.date_of_birth, 
vd.gender, 
vd.enrollment, 
vd.other_party, 
vd.county_code, 
vd.election_district, 
vd.legislative_district, 
vd.town_city, 
vd.ward, 
vd.congressional_district, 
vd.senate_district, 
vd.assembly_district, 
vd.last_voted_date, 
vd.last_voted_year, 
vd.last_voted_county, 
vd.previous_address, 
vd.last_registered_name, 
vd.county_voter_reg_num, 
vd.application_date, 
vd.application_source, 
vd.id_required, 
vd.id_required_met, 
vd.voter_status, 
vd.voter_status_reason, 
vd.inactive_date, 
vd.purge_date, 
vd.telephone, 
vd.email,
group_concat(distinct vh.election_name) as voter_history
FROM ".$matchtable." mf ";
$sqldata .= "JOIN dcnxs_ny.match_data md ON (md.queueid = mf.queueid and md.userid = ? and md.matchid = ?) LEFT JOIN dcnxs_ny.voter_data vd on (vd.nys_voter_id = md.matched_voter_id) LEFT JOIN dcnxs_ny.voter_history vh ON (vh.nys_voter_id = vd.nys_voter_id) GROUP BY vd.nys_voter_id";

try {
    $rsdata = $db->Execute($sqldata, $stmtParams);
} catch (ADODB_Exception $e) {
    $db->disconnect();
    die(dbErr($e->getMessage()));  
}
pearErr($db, ADODB_PEAR_Error());
unset($sqldata);
$arr_data = $rsdata->GetArray();          

$db->disconnect();

$filename = 'matched_'.$filename;
ob_start();
$tmpcsv = fopen('php://output', 'w');	
foreach ($arr_data as $k => $d) {
    if ($k == 0) {
        $file .= fputcsv($tmpcsv, array_keys($d));    
    }
    $file .= fputcsv($tmpcsv, array_values($d));
}
fclose($tmpcsv);
$filedata = ob_get_contents();
ob_end_clean();

header('Content-Type: text/csv');
header('Content-Disposition: attachment; filename="'.$filename.'"');
header('Content-Transfer-Encoding: binary');
header('Expires: 0');
header('Cache-Control: must-revalidate, post-check=0, pre-check=0');
header('Pragma: public');
echo $filedata;
exit();