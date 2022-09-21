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
$savedSearchName = $request['savedsearchname'];
$searchType = $request['searchtype'];
$savedQuery = $request['queryparameters'];
$recordCount = $request['recordcount'];
$routeName = $request['routename'];
$timeRan = $request['timeran'];
$timeSaved = $request['timesaved'];

// If params are null, die and throw error alert in vue
if (!$userID) {
    die('{"error": "No user ID provided"}');
}

if (!$savedSearchName) {
    die('{"error": "No name for saved list provided"}');
}
else {
    $savedSearchName = trim($savedSearchName);
}

if (!$savedQuery) {
    die('{"error": "Original search query not provided"}');
}

if (!$recordCount) {
    die('{"error": "No record count provided"}');
}

if (!$routeName) {
    die('{"error": "No route provided"}');
}

if (!$timeRan) {
    die('{"error": "No timestamp for search provided"}');
}

if (!$timeSaved) {
    die('{"error": "No timestamp for time of save provided"}');
}


//Connect to Donor Database
$db = db_conn('@nxsidx_app');

//Insert into saved_search table new saved search. save_id is auto-incremented on the table.
$userSearchSql = '';
$userSearchSql .= "INSERT INTO nxsidx_app.saved_searches (userid, save_name, search_type, search_parameters, record_count, route_name, time_ran, time_saved, time_modified) VALUES (?,?,?,?,?,?,CAST(? AS DATETIME),CAST(? AS DATETIME),CAST(? AS DATETIME))";

$userSearchParams = Array($userID, $savedSearchName, $searchType, $savedQuery, $recordCount, $routeName, $timeRan, $timeSaved, $timeSaved);

$userSearchStmt = $db->Prepare($userSearchSql);

try {
    $rs = $db->Execute($userSearchStmt, $userSearchParams);
    error_log(print_r($rs));
} catch (ADODB_Exception $e) {
    // $db->disconnect();
    die(dbErr($e->getMessage()));
}

$arr = $rs->GetArray();

echo json_encode($arr);

exit();
