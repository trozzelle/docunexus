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
$electionYear = $request['electionyear'];
$filingAbbrev = $request['filingabbrev'];
$committeeTypes = $request['committeetypes'];
$limit = $request['limit'];

if (!$electionYear) {
    die('{Error: no election year provided}');
}
if (!$filingAbbrev) {
    die('{Error: no filing selected}');
}
if (!$committeeTypes) {
    die('{Error: no committee type provided}');
}

if($committeeTypes) {

    $committeeTypesArray = [];

    foreach($committeeTypes as $type) {
        array_push($committeeTypesArray,$type->val);
    }

    $committeeTypes = $committeeTypesArray;

    $commAll = implode("','", $committeeTypes);
    $committeeTypes = "('" . strtoupper($commAll) . "')";

}

$db = db_conn('@nxsidx_ny');



$sql = "SELECT ROW_NUMBER() OVER (ORDER BY sbf.contributions DESC) as 'rank', fd.filer_id, fd.filer_name, fd.county_desc, fd.municipality_desc, sbf.election_year, sbf.contributions_ind_part,
       sbf.contributions_corp, sbf.contributions_corp, sbf.contributions_inkind, sbf.other_receipts, sbf.transfers_in,
       sbf.loans_received, sbf.contributions, sbf.net_raise, sbf.net_cash
FROM nys_transaction_data_summary_by_filing sbf
         JOIN nys_filer_data fd ON sbf.filer_id = fd.filer_id
WHERE sbf.election_year = '".$electionYear."'
AND sbf.filing_abbreviation = '".$filingAbbrev."'
AND fd.committee_type in ".$committeeTypes."
ORDER BY sbf.contributions DESC";

if($limit) {
    $sql .= " LIMIT " .$limit;
}

$stmt = $db->Prepare($sql);

try {
    $rs = $db->Execute($stmt);
} catch (ADODB_Exception $e) {
    $db->disconnect();
    die(dbErr($e->getMessage()));
}

$arr = $rs->GetArray();

echo json_encode($arr);

exit();
