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
$pageTitle = $request['pagetitle'];
$pageType = $request['pagetype'];
$pageLocation = $request['pagelocation'];
$routeName = $request['routename'];
$routeParams = $request['routeparams'];


if (trim($userID) > '')
{
    $userID = trim($userID);
}

if(trim($pageTitle) > ''){
    $pageTitle = trim($pageTitle);
}
else {
    $pageTitle = date("Unknown");
}

if (trim($pageType) > ''){
    $pageType = trim($pageType);
}

if (trim($pageLocation) > '') {
    $pageLocation = trim($pageLocation);
}

if (trim($routeName) > '') {
    $routeName = trim($routeName);
}

if (trim($routeParams) > '' ) {
    $routeParams = trim($routeParams);
}

//Connect to Donor Database
$db = db_conn('@nxsidx_app');

$sqlAll = '';
$sqlAll .= "INSERT INTO nxsidx_app.saved_pages(`userid`, `page_title`, `page_type`, `route_name`, `route_params`, `location`, `time_saved`, `time_modified`) VALUES (?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)";

$stmtParams = array($userID, $pageTitle, $pageType, $routeName, $routeParams, $pageLocation);


//Execute Query Section
$stmtAll = $db->Prepare($sqlAll);

//Replace with something more robust 
try {
    $db->Execute($stmtAll, $stmtParams);
} catch (ADODB_Exception $e) {
    $db->disconnect();
    die(dbErr($e->getMessage()));
}

exit();
