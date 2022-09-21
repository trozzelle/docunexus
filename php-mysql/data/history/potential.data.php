<?php 
ini_set('memory_limit', '768M');
ini_set('max_execution_time', 0);
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

$alphabet = array('A' => 0, 'B' => 1, 'C' => 2, 'D' => 3, 'E' => 4, 'F' => 5, 'G' => 6, 'H' => 7, 'I' => 8, 'J' => 9, 'K' => 10, 'L' => 11, 'M' => 12, 'N' => 13, 'O' => 14, 'P' => 15, 'Q' => 16, 'R' => 17, 'S' => 18, 'T' => 19, 'U' => 20, 'V' => 21, 'W' => 22, 'X' => 23, 'Y' => 24, 'Z' => 25, 'AA' => 26, 'AB' => 27, 'AC' => 28, 'AD' => 29, 'AE' => 30, 'AF' => 31, 'AG' => 32, 'AH' => 33, 'AI' => 34, 'AJ' => 35, 'AK' => 36, 'AL' => 37, 'AM' => 38, 'AN' => 39, 'AO' => 40, 'AP' => 41, 'AQ' => 42, 'AR' => 43, 'AS' => 44, 'AT' => 45, 'AU' => 46, 'AV' => 47, 'AW' => 48, 'AX' => 49, 'AY' => 50, 'AZ' => 51  );

$detailsql = "SELECT matchid, userid, matchfile_name, matchtable, matchmap, date_submitted, date_completed FROM dcnxs_ny.matches WHERE matchid = ? AND userid = ?";
$stmtParams = array($matchid, $userid);

$arr_result = array();

$db = db_conn('@dcnxs_ny');

$stmt = $db->Prepare($detailsql);
try {
    $rs = $db->Execute($stmt, $stmtParams);
} catch (ADODB_Exception $e) {
	$db->disconnect();
    die(dbErr($e->getMessage()));    
}
pearErr($db, ADODB_PEAR_Error());

$arr = $rs->GetArray();
$arr_result[] = $arr;

$matchmap = (array) json_decode($arr[0]['matchmap']);
$matchtable = $arr[0]['matchtable'];
$t = explode(".", $matchtable);
$schema = $t[0];
$table = $t[1];
$d = explode("_", $table);
$userid = $d[0];
$matchid = $d[1];

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

$colSql = 'SELECT ';

foreach ($matchmap as $alpha => $m) {
    //Column from submitted table
    $colSql .= '`'.$arr_cols[$alphabet[$alpha]+1]['COLUMN_NAME'].'` AS `'.$m->id.'`, ';    
}

$colSql .= 'm1.queueid, m2.matched_voter_id FROM '.$matchtable.' m1 JOIN match_data m2 ON m1.queueid = m2.queueid WHERE m2.userid = ? AND m2.matchid = ?';
unset($stmtParams);
$stmtParams = array($userid, $matchid);
$stmtcol = $db->Prepare($colSql);
try {
    $rs = $db->Execute($stmtcol, $stmtParams);
} catch (ADODB_Exception $e) {
	$db->disconnect();
    die(dbErr($e->getMessage()));    
}
pearErr($db, ADODB_PEAR_Error());
$arr = $rs->GetArray();

unset($stmtParams);
$stmtParams = array($userid, $matchid);
$sqlpotentials = "CALL dcnxs_ny.get_potentials(?, ?);";
$stmtpotentials = $db->Prepare($sqlpotentials);
try {
	$rs = $db->Execute($stmtpotentials, $stmtParams);
} catch (ADODB_Exception $e) {
	$db->disconnect();
	die(dbErr($e->getMessage()));
}
pearErr($db, ADODB_PEAR_Error());
$db->disconnect();
$arr_potentials = $rs->GetArray();
foreach ($arr_potentials as $p) {
    $potentials[$p['queueid']][] = $p;
}

foreach ($arr as $k => $a) {
    $arr[$k]['potentials'] = array();
    foreach ($potentials[$a['queueid']] as $p) {
        $arr[$k]['potentials'][] = $p;
    }
}

$arr_result[] = $arr;
echo json_encode($arr_result);
