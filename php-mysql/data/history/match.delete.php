<?php 
error_reporting(E_ALL & ~E_NOTICE);
ini_set('display_errors', TRUE); 
ini_set('display_startup_errors', TRUE); 

require_once ($_SERVER['DOCUMENT_ROOT'] . '/db.config.php');

//Check user authentication token
$arr_token = check_token($_REQUEST['token']);
if (count($arr_token)) { die(json_encode($arr_token)); }

$userid = $_REQUEST['userid'];
$matchid = $_REQUEST['matchid'];
if (!$userid) {
    die("{error: 'No user ID provided'}");
}
if (!$matchid) {
    die("{error: 'No match ID provided'}");
}

$sql = "CALL dcnxs_ny.delete_match(?, ?);";
$stmtParams = array($userid, $matchid);    
$db = db_conn('@dcnxs_ny');
try {
    $stmt = $db->Prepare($sql);
	$rs = $db->Execute($stmt, $stmtParams);
} catch (ADODB_Exception $e) {
	$db->disconnect();
	die(dbErr($e->getMessage()));
}
pearErr($db, ADODB_PEAR_Error());
$db->disconnect();
$arr = $rs->GetArray();

echo json_encode($arr);
