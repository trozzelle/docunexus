<?php
error_reporting(E_ALL & ~E_NOTICE);
ini_set("display_errors", 1);
//Database configuration
require_once ($_SERVER['DOCUMENT_ROOT'] . '/db.config.php');
//Check user authentication token
$arr_token = check_token($_REQUEST['token']);
if (count($arr_token)) { die(json_encode($arr_token)); }


$matchid = $_REQUEST['matchid'];
$userid = $_REQUEST['userid'];

if (!$matchid) {
    die('{"error": "No match ID provided"}');
}
if (!$userid) {
    die('{"error": "No user ID provided"}');
}


$db = db_conn('@dcnxs_ny');
$sql = "SELECT matchfile_name, matchtable, matchmap FROM dcnxs_ny.matches WHERE userid = ? AND matchid = ?";
$stmtParams = array($userid, $matchid);

try {
    $stmt = $db->Prepare($sql);
    $rs = $db->Execute($stmt, $stmtParams);
    $arr = $rs->GetArray();
} catch (ADODB_Exception $e) {
    $db->disconnect();
	die(dbErr($e->getMessage()));
}
pearErr($db, ADODB_PEAR_Error());


$matchtable = $arr[0]['matchtable'];
$matchmap = $arr[0]['matchmap'];
$t = explode(".", $matchtable);
$schema = $t[0];
$table = $t[1];
$filename = $arr[0]['matchfile_name'];

unset($rs);
unset($arr);

unset($stmtParams);
$stmtParams = array($schema, $table);

$sqlcols = "SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA=? AND TABLE_NAME=? ORDER BY ordinal_position";

$stmtcols = $db->Prepare($sqlcols);
try {
	$rscols = $db->Execute($stmtcols, $stmtParams);
} catch (ADODB_Exception $e) {
    $db->disconnect();
    die(dbErr($e->getMessage()));    
}
pearErr($db, ADODB_PEAR_Error());
unset($sqlcols);
$arr_cols = $rscols->GetArray();    

foreach ($arr_cols as $c) {
    switch ($c['COLUMN_NAME']) {
        case 'queueid':
        case 'nys_voter_id':
        break;
        default:
            $cols[] = "`".$c['COLUMN_NAME']."`";
        break;        
    }
}

$sqldata = "SELECT ".implode(',',$cols)." FROM ".$matchtable." LIMIT 5";  
$stmtdata = $db->Prepare($sqldata);
try {
	$rsdata = $db->Execute($stmtdata);
} catch (ADODB_Exception $e) {
    $db->disconnect();
    die(dbErr($e->getMessage())); 
} 
pearErr($db, ADODB_PEAR_Error());
unset($sqldata);
$arr_data = $rsdata->GetArray();    

foreach ($arr_data as $k => $d) {
    if ($k == 0) {
        $filedata[] = array_keys($d);    
    }
    $filedata[] = array_values($d);
}

$out = json_encode(array('file' => $filename, 'preview' => $filedata, 'mapping' => $mapping));
echo $out;
die();