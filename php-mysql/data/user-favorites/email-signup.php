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
$name = $request['name'];
$email = $request['email'];

if (trim($name) > '')
{
    $name = trim($name);
} else {
    die("No name provided");
}

if(trim($email) > ''){
    $email = trim($email);
} else {
    die("No email provided");
}

//Connect to Donor Database
$db = db_conn('@nxsidx_app');

$sqlAll = '';
$sqlAll .= "INSERT INTO nxsidx_app.email_list(`signup_name`, `signup_email`, `signup_time`) VALUES (?, ?, CURRENT_TIMESTAMP)";

$stmtParams = array($name, $email);


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
