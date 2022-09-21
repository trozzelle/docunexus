<?php
error_reporting(E_ALL & ~E_NOTICE);
ini_set("display_errors", 1);

require_once ($_SERVER['DOCUMENT_ROOT'] . '/db.config.php');

$user = $_REQUEST['user'];
$pass = $_REQUEST['pass'];

if (trim($user) == '') {
	die('{"error": "No username provided"}');
}
if (trim($pass) == '') {
	die('{"error": "No password provided"}');
}

$t = hash('sha512', HASH.$user.$pass);
$expFormat = mktime(date("H")+4, date("i"), date("s"), date("m") ,date("d"), date("Y"));
$expDate = date($expFormat);

$sql = "SELECT u.userid, u.username, u.email, u.display_name, u.enabled, u.site_admin,
g.groupid,
g.group_name,
ug.group_admin,
r.regionid,
r.region_name,
ur.region_admin,
'" . $t ."' as auth_token,
'" .$expDate. "' as auth_token_expires
FROM dcnxs_app.users u
LEFT JOIN dcnxs_app.user_groups ug
ON (ug.userid = u.userid)
LEFT JOIN dcnxs_app.user_regions ur
ON (ur.userid = u.userid)
LEFT JOIN dcnxs_app.groups g
ON (g.groupid = ug.groupid)
LEFT JOIN dcnxs_app.regions r
ON (r.regionid = ur.regionid)
WHERE u.username = ? AND u.password = ?
ORDER BY u.userid, g.groupid, r.regionid";

$sql_token = "UPDATE dcnxs_app.users u SET u.auth_token = ?, u.auth_token_expires = ? WHERE u.username = ?";

$db = db_conn('@dcnxs_app');

$stmtParams = array($user, hash('sha512', HASH.$pass));
$stmt = $db->Prepare($sql);

$stmt_tokenParams = array($t, $expDate, $user);
$stmt_token = $db->Prepare($sql_token);

try {
	$rs = $db->Execute($stmt, $stmtParams);
} catch (ADODB_Exception $e) {
	$db->disconnect();
    die(dbErr($e->getMessage()));    
}
try {
	$db->Execute($stmt_token, $stmt_tokenParams);
} catch (ADODB_Exception $e) {
	$db->disconnect();
    die(dbErr($e->getMessage()));    
}

$db->disconnect();

$arr = $rs->GetArray();

if ($arr[0]['username'] == $user) {	
	$expire = time()+(3600*12);		
	$cookie = formatUserData($arr);
	setcookie('docunexus-user', $cookie, $expire, '/');	
	die($cookie);
} else {
	die('{"error": "Your username or password is incorrect"}');
}
