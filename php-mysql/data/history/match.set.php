<?php 
error_reporting(E_ALL & ~E_NOTICE);
ini_set('display_errors', TRUE); 
ini_set('display_startup_errors', TRUE); 

require_once ($_SERVER['DOCUMENT_ROOT'] . '/db.config.php');

//Check user authentication token
$arr_token = check_token($_REQUEST['token']);
if (count($arr_token)) { die(json_encode($arr_token)); }

$matchid = $_REQUEST['matchid'];
$queueid = $_REQUEST['queueid'];
$voterid = $_REQUEST['voterid'];

if (!$matchid) {
    die("{error: 'No match ID provided'}");
}
if (!$queueid) {
    die("{error: 'No queue ID provided'}");
}

$sql = "UPDATE dcnxs_ny.match_data SET matched_voter_id = ? WHERE matchid = ? AND queueid = ?";
$stmtParams = array($voterid, $matchid, $queueid);

$db = db_conn('@dcnxs_ny');
$stmt = $db->Prepare($sql);
try {
	$db->Execute($stmt, $stmtParams);
} catch (ADODB_Exception $e) {
	$db->disconnect();
	die(dbErr($e->getMessage()));
}
pearErr($db, ADODB_PEAR_Error());
$db->disconnect();