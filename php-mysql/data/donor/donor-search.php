<?php

header('Access-Control-Allow-Origin: *');
/**
 * Donor Search endpoint.
 *
 * Takes array of search teams from Donor Search query and constructs a SQL query against the NYS_Transaction_Data_child
 * database and joined with NYS_Filer_Data to return contribution information for filers.
 *
 * @TODO DB must be normalized for optimization and this script will have to be refactored to join those tables
 *
 */


// Explicitly increase memory for script execution and time. Prior to optimization, some queries can take a long time.

ini_set('memory_limit', '2048M');
ini_set('max_execution_time', 6000);
ini_set('max_input_time', 6000);
set_time_limit(0);

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
if (count($arr_token)) {
    die(json_encode($arr_token));
}


//Initialize parameters for search
$donor_last_name = $request['donor_last_name'];
$donor_first_name = $request['donor_first_name'];
$donor_middle_name = $request['donor_middle_name'];
$donor_organization_name = $request['donor_organization_name'];
$election_year = $request['election_year'];
$filer_name = $request['filer_name'];
$filer_id = $request['filer_id'];
$filing = $request['filing'];
$filing_schedule = $request['filing_schedule'];
$donor_address = $request['donor_address'];
$donor_city = $request['donor_city'];
$donor_zip_low = $request['donor_zip_low'];
$donor_zip_high = $request['donor_zip_high'];
$original_amount_low = $request['original_amount_low'];
$original_amount_high = $request['original_amount_high'];
$transaction_date_low = $request['transaction_date_low'];
$transaction_date_high = $request['transaction_date_high'];
$limit = $request['limit'];
$offset = $request['offset'];
$action = $request['action'];
$transactionType = 'contributions';

$arrSql = array();

// Driver arrays for joining tables. As it stands, we only join on Filer Data but these are left in
// for the future.
// $selectSql = array();
$selectSql = '';
$driver = array();
$table = array('td' => 'nys_transaction_data_child');


// Test that parameters aren't empty, trim any whitespace, and cast necessary values
if (trim($limit) == '' || (int)trim($limit) > 1000) {
    $limit = '1000';
    $limitSet = false;
} else {
    $limitSet = true;
}

if (trim($donor_last_name) > '') {
    $arrSql['td'][] = "donor_last_name LIKE '" . strtoupper(trim($donor_last_name)) . "'";
}

if (trim($donor_first_name) > '') {
    $arrSql['td'][] = "donor_first_name LIKE '" . strtoupper(trim($donor_first_name)) . "'";
}

if (trim($donor_middle_name) > '') {
    $arrSql['td'][] = "donor_entity_middle_name LIKE '" . strtoupper(trim($donor_middle_name)) . "'";
}

if (trim($donor_organization_name) > '') {
    $arrSql['td'][] = "donor_organization_name LIKE '" . strtoupper(trim($donor_organization_name)) . "'";
}


if (trim($donor_address) > '') {
    $arrSql['td'][] = "donor_address LIKE '" . strtoupper(trim($donor_address)) . "'";

}

if (trim($donor_city) > '') {
    $arrSql['td'][] = "donor_city LIKE '" . strtoupper(trim($donor_city)) . "'";
}


if (trim($donor_zip_low) > '' || trim($donor_zip_high)) {

    if (trim($donor_zip_low) > '' && trim($donor_zip_high) > '') {
        $arrSql['td'][] = "donor_zip >= " . (int)trim($donor_zip_low) . " AND " . "donor_zip <= " . (int)trim($donor_zip_high);
    } elseif (trim($donor_zip_low) > '' && !$donor_zip_high) {
        $arrSql['td'][] = "donor_zip = " . (int)trim($donor_zip_low);
    } elseif (trim($donor_zip_high) > '' && !$donor_zip_low) {
        $arrSql['td'][] = "donor_zip = " . (int)trim($donor_zip_high);
    }
}

if (count($election_year) > 0 && $election_year != "") {
    $q = "election_year IN ('";
    $tmp = [];

    foreach ($election_year as $value) {
        $tmp[] = $value->year;
    }

    $q .= implode('\', \'', $tmp);
    $q .= "') ";
    $arrSql['td'][] = $q;

}

if (count($filing) > 0 && $filing != "") {
    $q = "filing_abbreviation IN ('";
    $tmp = array();

    foreach ($filing as $value) {
        $tmp [] = $value->abbreviation;
    }

    $q .= implode('\', \'', $tmp);
    $q .= "') ";
    $arrSql['td'][] = $q;
}

if (count($filing_schedule) > 0 && $filing_schedule != "") {
    $q = "filing_schedule_abbreviation IN ('";
    $tmp = array();

    foreach ($filing_schedule as $value) {
        $tmp [] = $value->abbreviation;
    }

    $q .= implode('\', \'', $tmp);
    $q .= "') ";
    $arrSql['td'][] = $q;
}


if (trim($original_amount_low) > '' || trim($original_amount_high) > '') {

    if (trim($original_amount_low) > '' && trim($original_amount_high) > '') {
        $arrSql['td'][] = "original_amount >= " . (float)trim($original_amount_low) . " AND " . "original_amount <= " . (float)trim($original_amount_high);
    } elseif (trim($original_amount_low) >= '') {
        $arrSql['td'][] = "original_amount >= " . (float)trim($original_amount_low);
    } elseif (trim($original_amount_high) >= '') {
        $arrSql['td'][] = "original_amount <= " . (float)trim($original_amount_high);
    }

}

if (trim($transaction_date_low) > '' || trim($transaction_date_high) > '') {

    if (trim($transaction_date_low) > '' && trim($transaction_date_high) > '') {
        $arrSql['td'][] = "transaction_date BETWEEN DATE('" . trim($transaction_date_low) . "') AND DATE('" . trim($transaction_date_high) . "')";
    } elseif (trim($transaction_date_low) >= '') {
        $arrSql['td'][] = "transaction_date >= DATE('" . trim($transaction_date_low) . "')";
    } elseif (trim($transaction_date_high) >= '') {
        $arrSql['td'][] = "transaction_date <= DATE('" . trim($transaction_date_high) . "')";
    }
}

// Add wildcard operators to filer names, as most queries will go along the lines of 'Candidate Name'
// and not the full committee name
if (trim($filer_name) > '') {
    $table['fn'] = 'nxsidx_ny.nys_filer_data';
    if (!count($driver)) {
        $driver['fn'] = 'nxsidx_ny.nys_filer_data';
    }
    $arrSql['fn'] = "filer_name LIKE '%" . strtoupper(trim($filer_name)) . "%'";
}

if (trim($filer_id) > '') {
    $arrSql['td'][] = "filer_id = '" . strtoupper(trim($filer_id)) . "'";
}


if (trim($transactionType) > '') {
    if ($transactionType = 'contributions') {
        $arrSql['td'][] = "filing_schedule_description in (  'MONETARY CONTRIBUTIONS RECEIVED FROM IND. & PART.',
                                                             'MONETARY CONTRIBUTIONS RECEIVED FROM CORPORATION',
                                                             'MONETARY CONTRIBUTIONS RECEIVED FROM ALL OTHER',
                                                             'EXPENDITURE REFUNDS (INCREASES BALANCE)',
                                                             'OUTSTANDING LIABILITIES/LOANS',
                                                             'LOANS RECEIVED',
                                                             'OTHER RECEIPTS RECEIVED',
                                                             'LIABILITIES/LOANS FORGIVEN',
                                                             'IN-KIND (NON-MONETARY) CONTRIBUTIONS RECEIVED',
                                                             'TRANSFERS IN',
                                                             'EXPENSE ALLOCATION AMONG CANDIDATES',
                                                             'NON-CAMPAIGN HOUSEKEEPING RECEIPTS')";
    }
}

/**
 * We are currently using a hard-coded select statement for development. This returns more data than is
 * probably necessary.
 *
 * @Todo Establish all necessary downstream columns and convert to dynamic select
 */

// Dynamic Select
// Columns always to select. Selections above should be added within their if statement as the form is developed.
// $selectSql['td'][] = "unique_id";
// $selectSql['td'][] = "donor_last_name";
// $selectSql['td'][] = "donor_first_name";
// $selectSql['td'][] = "donor_middle_name";
// $selectSql['td'][] = "donor_organization_name";
// $selectSql['td'][] = "donor_address";
// $selectSql['td'][] = "donor_city";
// $selectSql['td'][] = "donor_zip";
// $selectSql['td'][] = "donor_state";
// $selectSql['td'][] = "original_amount";
// $selectSql['td'][] = "transaction_date";
// $selectSql['td'][] = "transaction_number";
// $selectSql['td'][] = "filer_id";

//Array of fields for SELECT. Get only what we search for.
// $s = "";

// if(count($selectSql)) {
//     $tmp = array();

//     foreach ($selectSql['td'] as $a) {
//         $tmp[] = "td.".$a;
//     }

//     $s .= implode(", ",$tmp);
// }

$selectSql .= "td.unique_id,
                td.filer_id,
                td.filer_previous_id,
                td.candidate_committee_name,
                td.election_year,
                td.election_type,
                td.filing_abbreviation,
                td.filing_description,
                td.is_amended,
                td.filing_schedule_abbreviation,
                td.filing_schedule_description,
                td.transaction_number,
                td.transaction_date,
                td.contributor_type,
                td.contribution_type,
                td.transfer_type,
                td.receipt_type,
                td.purpose_code,
                td.donor_organization_name,
                td.donor_first_name,
                td.donor_middle_name,
                td.donor_last_name,
                td.donor_address,
                td.donor_city,
                td.donor_state,
                td.donor_zip,
                td.payment_type,
                td.payment_number,
                td.original_amount,
                td.loan_type,
                td.transaction_explanation,
                td.is_itemized,
                td.is_liability";

$driverKey = key($driver);

$q = "";

//Joining other tables
foreach ($table as $key => $value) {
    if ($key == 'dd') {
        continue;
    }
    if ($key == 'fn') {
        $q .= "JOIN " . $value . " " . $key . " on " . $key . "." . $arrSql[$key] . " AND td.filer_id = " . $key . ".filer_id";
    }
}

//Constructing filters
if (count($arrSql['td'])) {
    $q .= " WHERE ";
    $tmp = array();
    foreach ($arrSql['td'] as $a) {
        $tmp[] = "td." . $a;
    }
    $q .= implode(" AND ", $tmp);
}

//Connect to Donor Database
$db = db_conn('@nxsidx_ny');

$sqlAll = '';

//We're returning everything right now for development purposes.
$sqlAll .= "WITH td AS (SELECT td.* FROM nxsidx_ny.nys_transaction_data_child td ";

if ($q) {
    $sqlAll .= $q;
}

$sqlCount = '';

// Add existing query to a separate count query
$sqlCount .= $sqlAll . ") SELECT * FROM td";


if ($action == 'query') {
    $sqlAll .= " LIMIT " . $limit . " ";
} else {
    if ($limitSet) {
        $sqlAll .= " LIMIT " . $limit;
    }
}

$sqlAll .= ") SELECT " . $selectSql . ", fd.filer_name, fd.committee_type FROM td JOIN nxsidx_ny.nys_filer_data fd on td.filer_id = fd.filer_id ";
$sqlAll .= "ORDER BY td.donor_last_name, td.donor_first_name;";

//Execute
$stmtAll = $db->Prepare($sqlAll);

try {
    $rsAll = $db->Execute($stmtAll);
} catch (ADODB_Exception $e) {
    $db->disconnect();
    die(dbErr($e->getMessage()));
}

pearErr($db, ADODB_PEAR_Error());
$arrAll = $rsAll->GetArray();
switch ($action) {
    case 'query':
        $stmtCount = $db->Prepare($sqlCount);
        try {
            $rsCount = $db->Execute($stmtCount);
        } catch (ADODB_Exception $e) {
            $db->disconnect();
            die(dbErr($e->getMessage()));
        }
        pearErr($db, ADODB_PEAR_Error());

        $arrCount = array();
        $arrCount[] = array('records' => count($rsCount->getArray()));     
        $db->disconnect();
        $arr = array($arrCount, $arrAll);
        echo json_encode($arr);
        break;
    case 'download':
        $db->disconnect();
        ob_start();
        $tmpcsv = fopen('php://output', 'w');
        foreach ($arrAll as $k => $d) {
            if ($k == 0) {
                $file .= fputcsv($tmpcsv, array_keys($d));
            }
            $file .= fputcsv($tmpcsv, array_values($d));
        }
        fclose($tmpcsv);
        $filedata = ob_get_contents();
        ob_end_clean();
        header('Content-Type: text/csv');
        header('Content-Disposition: attachment; filename="quick-lookup-download.csv"');
        header('Content-Transfer-Encoding: binary');
        header('Expires: 0');
        header('Cache-Control: must-revalidate, post-check=0, pre-check=0');
        header('Pragma: public');
        echo $filedata;
        break;
}
exit();
