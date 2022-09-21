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
$electionYear = $request['electionyear'];
$filingAbbreviation = $request['filingabbreviation'];
$transactionType = $request['transactiontype'];
//Future implementation
// $transactionDateLow = $_REQUEST['transactiondatelow'];
// $transactionDateHigh = $_REQUEST['transactiondatehigh'];

$contributionsKey = "'A',	'B',	'C',	'D',	'E',	'G',	'I',	'L',	'P'";
$expendituresKey = "'F',	'H',	'J',	'K',	'M',	'Q'";
$filingScheduleAbbreviation = "'A',	'B',	'C',	'D',	'E',	'F',	'G',	'H',	'I',	'J',	'K',	'L',	'M',	'P',	'Q'";


if(!$filerID) {
    die("{error: 'No Filer ID provided'}");
}

if(!$electionYear) {
    die("{error: 'No election year provided'}");
}

if(!$filingAbbreviation) {
    die("{error: 'No filing key provided'}");
}

if(!$transactionType) {
    die("{error: 'No transaction type provided'}");
} else {
    if ($transactionType == 'CONTRIBUTIONS') {
        $filingScheduleAbbreviation = $contributionsKey;
    }
    elseif ($transactionType == 'EXPENDITURES') {
        $filingScheduleAbbreviation = $expendituresKey;
    }
}

$sqlAll = 'SELECT td.unique_id, td.filer_id, td.election_year, td.filing_abbreviation, td.filing_schedule_abbreviation, td.loan_liability_id, td.transaction_number, td.transaction_date, td.contributor_type, td.contribution_type, td.transfer_type, td.receipt_type, td.receipt_code, td.purpose_code, td.is_subcontractor, td.donor_organization_name, td.donor_first_name, td.donor_middle_name, td.donor_last_name, td.donor_address, td.donor_city, td.donor_state, td.donor_zip, td.donor_country, td.payment_type, td.payment_number, td.owed_amount, td.original_amount, td.loan_type, td.transaction_explanation, td.is_itemized, td.is_liability
          FROM nxsidx_ny.nys_transaction_data_child td
          WHERE td.filer_id = ' .$filerID.' 
          AND td.election_year = ' .$electionYear.' 
          AND td.filing_abbreviation = \''.$filingAbbreviation.'\'
          AND td.filing_schedule_abbreviation IN ('.$filingScheduleAbbreviation.')';

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