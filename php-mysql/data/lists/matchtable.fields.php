<?php
error_reporting(E_ALL & ~E_NOTICE);
ini_set("display_errors", 1);
//Database configuration
require_once ($_SERVER['DOCUMENT_ROOT'] . '/db.config.php');

//Check user authentication token
$arr_token = check_token($_REQUEST['token']);
if (count($arr_token)) { die(json_encode($arr_token)); }

$matchid = $_REQUEST['matchid'];
$tablename = $_REQUEST['tablename'];
$operators = array(
    array('code' => '=', 'display' => 'Equal to', 'label' => 'EQUAL'),
    array('code' => '!=', 'display' => 'Not equal to', 'label' => 'NOTEQUAL'),
    array('code' => 'LIKE', 'display' => 'Is like', 'label' => 'LIKE'),
    array('code' => 'NOT LIKE', 'display' => 'Is not like', 'label' => 'NOTLIKE'),
    array('code' => '>', 'display' => 'Greater than', 'label' => 'GREATERTHAN'),
    array('code' => '<', 'display' => 'Less than', 'label' => 'LESSTHAN'),
    array('code' => 'IN', 'display' => 'Is in this list', 'label' => 'IN'),
    array('code' => 'NOT IN', 'display' => 'Is not in this list', 'label' => 'NOTIN'),
    array('code' => 'BETWEEN', 'display' => 'Is between', 'label' => 'BETWEEN'),
    array('code' => 'IS NULL', 'display' => 'Is empty', 'label' => 'NULL'),
    array('code' => 'IS NOT NULL', 'display' => 'Is not empty', 'label' => 'NOTNULL')
);

$repoperators = array(
    array('code' => '=', 'display' => 'Equal to', 'label' => 'EQUAL'),
    array('code' => '!=', 'display' => 'Not equal to', 'label' => 'NOTEQUAL'),
    array('code' => 'IN', 'display' => 'Is in this list', 'label' => 'IN'),
    array('code' => 'NOT IN', 'display' => 'Is not in this list', 'label' => 'NOTIN'),
    array('code' => 'IS NULL', 'display' => 'Is empty', 'label' => 'NULL'),
    array('code' => 'IS NOT NULL', 'display' => 'Is not empty', 'label' => 'NOTNULL')
);

if (!$matchid && !$tablename) {
    die('{"error": "No datasource provided"}');
}
$db = db_conn('@dcnxs_ny');
if ($matchid) {
    $sqltbl = "SELECT matchtable FROM matches WHERE matchid = ?";
    $stmtParams = array($matchid);
    $stmttbl = $db->Prepare($sqltbl);
    try {
        $rs = $db->Execute($stmttbl, $stmtParams);
    } catch (ADODB_Exception $e) {
        $db->disconnect();
        die(dbErr($e->getMessage()));
        pearErr($db, ADODB_PEAR_Error());
    }
    $arrtbl = $rs->GetArray();
    $fulltable =  $arrtbl[0]['matchtable'];
}
if ($tablename) {
    $fulltable = $tablename;
}
$t = explode(".", $fulltable);
$schema = $t[0];
$table = $t[1];

if (!$schema || !$table) {
    if ($matchid) {
        $db->disconnect();
    }
    die('{"error": "Source table could not be found"}');
}

unset($stmtParams);
$stmtParams = array($schema, $table);

$sql = "SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH FROM INFORMATION_SCHEMA.COLUMNS WHERE COLUMN_NAME != 'queueid' AND TABLE_SCHEMA=? AND TABLE_NAME=?";

$stmt = $db->Prepare($sql);
try {
	$rs = $db->Execute($stmt, $stmtParams);
} catch (ADODB_Exception $e) {
	$db->disconnect();
    die(dbErr($e->getMessage()));    
}
pearErr($db, ADODB_PEAR_Error());

unset($stmtParams);
$stmtParams = array($schema);

$sqlvd = "SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA=? AND TABLE_NAME='voter_data'";

$stmtvd = $db->Prepare($sqlvd);
try {
	$rsvd = $db->Execute($stmtvd, $stmtParams);
} catch (ADODB_Exception $e) {
	$db->disconnect();
    die(dbErr($e->getMessage()));   
} 
pearErr($db, ADODB_PEAR_Error());

$db->disconnect();

$arr[0] = $rs->GetArray();

foreach ($arr[0] as $k => $a) {
    $arr[0][$k]['OPERATORS'] = $operators;
} 


$arr[1] = $rsvd->getArray();
foreach ($arr[1] as $k => $a) {
    $arr[1][$k]['OPERATORS'] = $operators;
} 


//Add rep lookup columns
if ($schema == 'dcnxs_ny') {
    $arr[1][] = array('COLUMN_NAME' => 'assembly_rep', 'OVERRIDE_FIELD' => 'assembly_district', 'DATA_TYPE' => 'varchar', 'CHARACTER_MAXIMUM_LENGTH' => '255', 'OPERATORS' => $repoperators);
    $arr[1][] = array('COLUMN_NAME' => 'congressional_rep', 'OVERRIDE_FIELD' => 'congressional_district', 'DATA_TYPE' => 'varchar', 'CHARACTER_MAXIMUM_LENGTH' => '255', 'OPERATORS' => $repoperators);
    $arr[1][] = array('COLUMN_NAME' => 'senate_rep', 'OVERRIDE_FIELD' => 'senate_district', 'DATA_TYPE' => 'varchar', 'CHARACTER_MAXIMUM_LENGTH' => '255', 'OPERATORS' => $repoperators);
}

$arr[1][] = array('CHARACTER_MAXIMUM_LENGTH' => '4', 'COLUMN_NAME' => 'year_voted', 'DATA_TYPE' => 'varchar', 'OPERATORS' => $operators);
$arr[2] = $fulltable;
echo json_encode($arr);