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

//Initialize
$userID = $request['userid'];
$rowIDs = $request['rowids'];
$savedListName = $request['savedlistname'];
$searchType = $request['searchtype'];
$searchParameters = $request['queryparameters'];
$recordCount = $request['recordcount'];
$routeName = $request['routename'];
$timeRan = $request['timeran'];
$timeSaved = $request['timesaved'];


// If params are null, die and throw error alert in vue
if (!$userID) {
    die('{"error": "No user ID provided"}');
}

if (!$rowIDs) {
    die('{"error": "No rows provided"}');
}

if (!$savedListName) {
    die('{"error": "No name for saved list provided"}');
}
else {
    $savedListName = trim($savedListName);
}

if (!$searchParameters) {
    die('{"error": "Original search query not provided"}');
}

if (!$recordCount) {
    die('{"error": "No record count provided"}');
}

if (!$routeName) {
    die('{"error": "No route provided"}');
}

if (!$timeRan) {
    die('{"error": "No timestamp for time search executed provided"}');
}

if (!$timeSaved) {
    die('{"error": "No timestamp for save time of search provided"}');
}

if(count($rowIDs) > 0) {
    $rowIDs = implode(',', $rowIDs);
}

// The query takes metadata and a list of all of the row IDs from a search query and saved just those records to a
// a user-specific table.


// Ideally all of the following would be done in stored procedures but I'm not able to make the
// store procedure call work from PHP. Sending the parameter as a text variable, which should have sufficient size,
// is not working reliably outside of an IDE.

// Left in as reference. nxsidx_save_user_list takes 3 parameters. rowids is a string of comma-separated integers.
// $sqlAll = '';
// $sqlAll .= 'CALL nxsidx_user_lists.nxsidx_save_user_list('.$userID.','.$saveID.',\''.$rowIDs.'\');';

// Connect to Donor Database. 
$db = db_conn('@nxsidx_lists');

// Create the user's saved list table if it doesn't exist. Uses a template table for portability
// and to carry over indexes/constraints
$createUserSaveTableQuery = 'CREATE TABLE IF NOT EXISTS nxsidx_user_lists.' .$userID. '_saved_lists LIKE nxsidx_user_lists.template';
$createUserSaveTablersp = $db->Execute($createUserSaveTableQuery);


// Get the last save ID and increment. If null (no saved lists yet), save id is 1
$saveIDQuery = 'SELECT MAX(saveid) as Max_ID FROM nxsidx_app.saved_lists WHERE userid = ' .$userID;
$saveIDrsp = $db->Execute($saveIDQuery);

$saveID = $saveIDrsp->fields['Max_ID'] + 1;


// Start the following two queries as a smart transaction. In case one fails, both get rolled back.
$db->startTrans();


// Insert into user saved list table. Can't bind the dynamic table name or row IDs.
// TODO: Write custom bind for table name and row IDs

$userListInsertStmt = 'INSERT INTO nxsidx_user_lists.'.$userID.'_saved_lists (userid, saveid, unique_id, row_hash, filer_id, filer_previous_id, candidate_committee_name, election_year, election_type,
county_description, filing_abbreviation, filing_description, is_amended, filing_category_description, filing_schedule_abbreviation,
filing_schedule_description, loan_liability_id, transaction_number, transaction_mapping, transaction_date, transaction_parent_date,
contributor_type, contribution_type, transfer_type, receipt_type, receipt_code, purpose_code, is_subcontractor, donor_organization_name,
donor_first_name, donor_middle_name, donor_last_name, donor_address, donor_city, donor_state, donor_zip, donor_country, payment_type,
payment_number, owed_amount, original_amount, loan_type, transaction_explanation, is_itemized, is_liability, candidate_election_year,
candidate_office, candidate_district, district_office_candidate_ballot_proposition, imported_timestamp, updated_timestamp, saved_timestamp)';

$userListSelectStmt = 'SELECT '.$userID.', '.$saveID.', unique_id, row_hash_fk, filer_id, filer_previous_id, candidate_committee_name,
election_year, election_type, county_description, filing_abbreviation, filing_description, is_amended, filing_category_description,
filing_schedule_abbreviation, filing_schedule_description, loan_liability_id, transaction_number, transaction_mapping, transaction_date,
transaction_parent_date, contributor_type, contribution_type, transfer_type, receipt_type, receipt_code, purpose_code, is_subcontractor,
donor_organization_name, donor_first_name, donor_middle_name, donor_last_name, donor_address, donor_city, donor_state, donor_zip,
donor_country, payment_type, payment_number, owed_amount, original_amount, loan_type, transaction_explanation, is_itemized, is_liability,
candidate_election_year, candidate_office, candidate_district, district_office_candidate_ballot_proposition, imported_timestamp, updated_timestamp,
CURRENT_TIMESTAMP
FROM nxsidx_ny.nys_transaction_data_child';

$userListWhereStmt = 'WHERE unique_id IN ('.$rowIDs.');';

$userListSql = $userListInsertStmt. ' ' .$userListSelectStmt. ' ' .$userListWhereStmt;

try {
    $rsAll = $db->Execute($userListSql);
    error_log(print_r($db->affected_rows(), true));
    // $db->disconnect();
    echo "Success";
} catch (ADODB_Exception $e) {
    // $db->disconnect();
    die(dbErr($e->getMessage()));
}

// Insert record of saved list into saved_lists table
$saveListSql = 'INSERT INTO nxsidx_app.saved_lists (saveid, userid, save_name, search_type, search_parameters, 
                                    record_count, route_name, time_ran, time_saved, time_modified) VALUES (?,?,?,?,?,?,?,?,?,?)';

$saveListParams = array($saveID, $userID, $savedListName, $searchType, $searchParameters, $recordCount, $routeName, $timeRan, $timeSaved, $timeSaved);

$saveListStmt = $db->prepare($saveListSql);

try {
    $rsAll = $db->Execute($saveListStmt, $saveListParams);
    error_log(print_r($db->affected_rows(), true));
    // $db->disconnect();
} catch (ADODB_Exception $e) {
    // $db->disconnect();
    die(dbErr($e->getMessage()));
}

//Commit transaction
$db->completeTrans();

exit();
