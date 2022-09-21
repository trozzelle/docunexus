<?php 
error_reporting(E_ALL & ~E_NOTICE);
ini_set('display_errors', TRUE); 
ini_set('display_startup_errors', TRUE); 

require_once ($_SERVER['DOCUMENT_ROOT'] . '/db.config.php');

//Check user authentication token
$t = json_decode($_REQUEST['token']);
$token[] = json_encode($t[0]);  
$arr_token = check_token($token);
if (count($arr_token)) { die(json_encode($arr_token)); }

$userid = $_REQUEST['userid'];
$matchid = $_REQUEST['matchid'];
if (!$userid) {
    die("{error: 'No user ID provided'}");
}
if (!$matchid) {
    die("{error: 'No match ID provided'}");
}

$stmtParams = array($userid, $matchid);

$sql = "SELECT matchfile_name, matchtable FROM dcnxs_ny.matches WHERE userid = ? AND matchid = ?";

$db = db_conn('@dcnxs_ny');

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
$t = explode(".", $matchtable);
$schema = $t[0];
$table = $t[1];
$filename = $arr[0]['matchfile_name'];

unset($rs);
unset($arr);
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

$sqldata = "SELECT ".implode(',',$cols)." FROM ".$matchtable;    
try {
    $rsdata = $db->Execute($sqldata);
} catch (ADODB_Exception $e) {
    $db->disconnect();
    die(dbErr($e->getMessage()));
}
pearErr($db, ADODB_PEAR_Error());
unset($sqldata);
$arr_data = $rsdata->GetArray();    

ob_start();
$tmpcsv = fopen('php://output', 'w');		
foreach ($arr_data as $k => $d) {
    if ($k == 0) {
        $file .= fputcsv($tmpcsv, array_keys($d));    
    }
    $file .= fputcsv($tmpcsv, array_values($d));
}
fclose($tmpcsv);
$filedata = ob_get_contents();
ob_end_clean();

header('Content-Type: text/csv');
header('Content-Disposition: attachment; filename="'.$filename.'"');
header('Content-Transfer-Encoding: binary');
header('Expires: 0');
header('Cache-Control: must-revalidate, post-check=0, pre-check=0');
header('Pragma: public');
echo $filedata;
exit();
