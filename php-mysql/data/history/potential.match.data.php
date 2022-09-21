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
$start = $_REQUEST['start'];
$end = $_REQUEST['end'];
if (!$userid) {
    die("{error: 'No user ID provided'}");
}
if (!$matchid) {
    die("{error: 'No match ID provided'}");
}
/*if (!$start) {
    die("{error: 'No starting queueid provided'}");
}
if (!$end) {
    die("{error: 'No ending queueid ID provided'}");
}*/

$sql = "CALL dcnxs_ny.get_potentials(?, ?);";
$stmtParams = array($userid, $matchid);   
$db = db_conn('@dcnxs_ny');
$stmt = $db->Prepare($sql);
try {
	$rs = $db->Execute($stmt, $stmtParams);
} catch (ADODB_Exception $e) {
	$db->disconnect();
	die(dbErr($e->getMessage()));
}
pearErr($db, ADODB_PEAR_Error());
$db->disconnect();
$arr = $rs->GetArray();

echo json_encode($arr);
