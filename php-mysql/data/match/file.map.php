<?php
error_reporting(E_ALL & ~E_NOTICE);
ini_set("display_errors", 1);
//Database configuration
require_once ($_SERVER['DOCUMENT_ROOT'] . '/db.config.php');

//Check user authentication token
$t = json_decode($_REQUEST['token']);
$token[] = json_encode($t[0]);  
$arr_token = check_token($token);
if (count($arr_token)) { die(json_encode($arr_token)); }

$userid = $_REQUEST['userid'];
$map = $_REQUEST['map'];

function testField($field, &$arr) {
    if (in_array(trim($field), $arr) || $field == 'queueid') { //Field exists
        $field = $field.'_1'; 
        testField($field, $arr);
    } else {
        $arr[] = $field;
    }
}

//Check if the upload is valid
try {
    //throw new RuntimeException('multiple files/invalid parameters');
    // Undefined | Multiple Files | $_FILES Corruption Attack
    // If this request falls under any of them, treat it invalid.
    if (!isset($_FILES['file']['error']) || is_array($_FILES['file']['error'])) {
        throw new RuntimeException('multiple files/invalid parameters');
    }

    // Check $_FILES['file']['error'] value.
    switch ($_FILES['file']['error']) {
        case UPLOAD_ERR_OK:
            break;
        case UPLOAD_ERR_NO_FILE:
            throw new RuntimeException('No file sent');
        case UPLOAD_ERR_INI_SIZE:
        case UPLOAD_ERR_FORM_SIZE:
            throw new RuntimeException('Upload filesize exceeded');
        default:
            throw new RuntimeException('Unknown file upload error');
    }
	
    //$mimes = array('application/vnd.ms-excel','text/plain','text/csv','text/tsv');
    //if (!in_array($_FILES['file']['type'], $mimes)) {
    //    throw new RuntimeException('Invalid mimetype: '.$_FILES['file']['type']);
    //}
	
} catch (RuntimeException $e) {
    die(sprintf('{"error": "%s"}',  $e->getMessage()));
}

//The file was uploaded ok, add it to the database and return the HISTORY_SEQUENCE value back to the app, as well as the first five rows for mapping
$file = file_get_contents($_FILES['file']['tmp_name']);
$filename = $_FILES['file']['name'];

//Add record to match table
$db = db_conn('@dcnxs_ny');

$stmtParams = array($userid, $filename, $map);

$sql = "CALL dcnxs_ny.add_match(?, ?, ?);";      
$stmt = $db->Prepare($sql);
try {
	$rs = $db->Execute($stmt, $stmtParams);
} catch (ADODB_Exception $e) {
	$db->disconnect();
    die(dbErr($e->getMessage()));
}
pearErr($db, ADODB_PEAR_Error());
unset($sql);

$arr = $rs->GetArray();
$db->disconnect();
$db = db_conn('@dcnxs_ny');

$matchid = $arr[0]['matchid'];
$schema = "dcnxs_ny";
$tablename = $schema.".".$userid."_".$matchid."_match";
$sqltablename = "UPDATE `matches` SET matchtable = ? WHERE matchid = ? AND userid = ?";

unset($stmtParams);
$stmtParams = array($tablename, $matchid, $userid);

$stmttablename = $db->Prepare($sqltablename);

try {
	$db->Execute($stmttablename, $stmtParams);
} catch (ADODB_Exception $e) {		
	$db->disconnect();
    die(dbErr($e->getMessage()));
}
pearErr($db, ADODB_PEAR_Error());

//Create the match table
$sqlcreate = "CREATE TABLE IF NOT EXISTS ".$tablename." (queueid INT NOT NULL,";
$sqlinsert = "REPLACE INTO ".$tablename." VALUES ";

$arrCreate = array();

$csv = explode(PHP_EOL, $file);
$ignore = array();
foreach ($csv as $key => $fullrow) {	    
    $data = str_getcsv($fullrow);  
    $arrFields = array();  
    if ($key == 0) {        
        foreach ($data as $k => $d) {
            if (trim($d) == '') {
                $ignore[] = $k;
            } else {                
                testField($d, $arrFields);
            }
        }
        $c = count($data);
        foreach ($arrFields as $f) {
            $sqlcreate .= "`".trim($f)."` VARCHAR(255) NULL,";
        }
    } else {
        $ins = "(".$key.",";
        if (count($data) == $c) {
            foreach ($data as $x => $d) {            
                if (!in_array($x, $ignore)) {
                    $ins .= "'".oraEscape($d)."',";
                }            
            }
            $ins = rtrim($ins, ",")."),";            
            $sqlinsert .= $ins;
        }
    }        
}

$sqlcreate .= " PRIMARY KEY (queueid))";
$sqlinsert = substr(trim($sqlinsert), 0, -1);

$stmtcreate = $db->Prepare($sqlcreate);

//Create table
try {
    $db->Execute($stmtcreate);
} catch (ADODB_Exception $e) {		
    $db->disconnect();
    die(dbErr($e->getMessage()));
}
pearErr($db, ADODB_PEAR_Error());

//Insert into new table
$stmtinsert = $db->Prepare($sqlinsert);
try {
    $db->Execute($stmtinsert);
} catch (ADODB_Exception $e) {		
    $db->disconnect();
    die(dbErr($e->getMessage()));
}
pearErr($db, ADODB_PEAR_Error());

$db->disconnect();
die();