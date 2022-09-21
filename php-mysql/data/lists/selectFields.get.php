<?php
error_reporting(E_ALL & ~E_NOTICE);
ini_set("display_errors", 1);
//Database configuration
require_once ($_SERVER['DOCUMENT_ROOT'] . '/db.config.php');

//Check user authentication token
$arr_token = check_token($_REQUEST['token']);
if (count($arr_token)) { die(json_encode($arr_token)); }

$db = db_conn('@dcnxs_ny');
$sqla = "SELECT assembly_district as val, CONCAT(assembly_district, ' - ', representative) as display, assembly_district, representative, party FROM dcnxs_ny.assembly_rep ORDER BY LPAD(assembly_district, 3, '0')";
$sqlc = "SELECT congressional_district as val, CONCAT(congressional_district, ' - ', representative) as display, congressional_district, representative, party FROM dcnxs_ny.congressional_rep ORDER BY LPAD(congressional_district, 3, '0')";
$sqls = "SELECT senate_district as val, CONCAT(senate_district, ' - ', representative) as display, senate_district, representative, party FROM dcnxs_ny.senate_rep ORDER BY LPAD(senate_district, 3, '0')";
$sqle = "SELECT code as val, description as display, code, description FROM dcnxs_ny.enrollment ORDER BY description";
$sqlco = "SELECT county_code as val, county_name as display, county_code, county_name FROM dcnxs_ny.nys_counties ORDER BY county_name";


$stmta = $db->Prepare($sqla);
try {
	$rsa = $db->Execute($stmta);
} catch (ADODB_Exception $e) {
	$db->disconnect();
    die(dbErr($e->getMessage()));   
}
pearErr($db, ADODB_PEAR_Error());
unset($sqla);
unset($stmta);

$stmtc = $db->Prepare($sqlc);
try {
	$rsc = $db->Execute($stmtc);
} catch (ADODB_Exception $e) {
	$db->disconnect();
    die(dbErr($e->getMessage()));   
}
pearErr($db, ADODB_PEAR_Error());
unset($sqlc);
unset($stmtc);

$stmts = $db->Prepare($sqls);
try {
	$rss = $db->Execute($stmts);
} catch (ADODB_Exception $e) {
	$db->disconnect();
    die(dbErr($e->getMessage()));   
}
pearErr($db, ADODB_PEAR_Error());
unset($sqls);
unset($stmts);

$stmte = $db->Prepare($sqle);
try {
	$rse = $db->Execute($stmte);
} catch (ADODB_Exception $e) {
	$db->disconnect();
    die(dbErr($e->getMessage()));   
}
pearErr($db, ADODB_PEAR_Error());
unset($sqle);
unset($stmte);

$stmtco = $db->Prepare($sqlco);
try {
	$rsco = $db->Execute($stmtco);
} catch (ADODB_Exception $e) {
	$db->disconnect();
    die(dbErr($e->getMessage()));   
}
pearErr($db, ADODB_PEAR_Error());
unset($sqlco);
unset($stmtco);



$arr['assembly_rep'] = $rsa->GetArray();
$arr['congressional_rep'] = $rsc->GetArray();
$arr['senate_rep'] = $rss->GetArray();
$arr['enrollment'] = $rse->GetArray();
$arr['counties'] = $rsco->GetArray();
$db->disconnect();

echo json_encode($arr);