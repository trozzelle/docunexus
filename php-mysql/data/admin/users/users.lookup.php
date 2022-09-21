<?php 
error_reporting(E_ALL & ~E_NOTICE);
ini_set("display_errors", 1);
require_once ($_SERVER['DOCUMENT_ROOT'] . '/db.config.php');

//Check user authentication token
$arr_token = check_token($_REQUEST['token']);
if (count($arr_token)) { die(json_encode($arr_token)); }

$userid = $_REQUEST['userid'];
$site_admin = $_REQUEST['site_admin'];

$sql = "SELECT u.userid, u.username, u.email, u.display_name, u.enabled, u.site_admin,
g.groupid,
g.group_name,
ug.group_admin,
r.regionid,
r.region_name,
ur.region_admin
FROM dcnxs_app.users u
LEFT JOIN dcnxs_app.user_groups ug
ON (ug.userid = u.userid)
LEFT JOIN dcnxs_app.user_regions ur
ON (ur.userid = u.userid)
LEFT JOIN dcnxs_app.groups g
ON (g.groupid = ug.groupid)
LEFT JOIN dcnxs_app.regions r
ON (r.regionid = ur.regionid)";
if ($site_admin == 'N') {    
    $stmtParams = array($userid, $userid, $userid);
    $sql .= "WHERE (g.groupid IN (SELECT groupid FROM dcnxs_app.user_groups WHERE userid = ? AND group_admin = 'Y') OR g.groupid IS NULL)
    OR (r.regionid IN (SELECT regionid FROM dcnxs_app.user_regions WHERE userid = ? AND region_admin = 'Y') OR r.regionid IS NULL) 
    OR (u.userid = ?)";
}
$sql .= "ORDER BY u.userid, g.groupid, r.regionid";

$db = db_conn('@dcnxs_app');

$stmt = $db->Prepare($sql);
try {
    if ($site_admin == 'N') {    
        $rs = $db->Execute($stmt, $stmtParams);
    }
    $rs = $db->Execute($stmt);
} catch (ADODB_Exception $e) {
    $db->disconnect();
    die(dbErr($e->getMessage()));  
}
pearErr($db, ADODB_PEAR_Error());
$db->disconnect();

$arr = $rs->GetArray();

$uid = '';

$arr_out = array();
foreach ($arr as $a) {
	if ($a['userid'] != $uid) {
		$uid = $a['userid'];
		$arr_out[$uid] = array(
			'userid' => $a['userid'],
            'username' => $a['username'],
            'email' => $a['email'],
            'display_name' => $a['display_name'],
            'site_admin' => $a['site_admin'],
            'enabled' => $a['enabled'],
            'groups' => array(),
            'regions' => array()
		);		
	}
	if ($a['groupid']) {
        $arr_out[$uid]['groups'][$a['groupid']] = array('groupid' => $a['groupid'], 'group_name' => $a['group_name'], 'group_admin' => $a['group_admin']);        
    }
    if ($a['regionid']) {
        $arr_out[$uid]['regions'][$a['regionid']] = array('regionid' => $a['regionid'], 'region_name' => $a['region_name'], 'region_admin' => $a['region_admin']);        
	}
}

foreach ($arr_out as $k => &$user) {
    $user['groups'] = array_values($user['groups']);
    $user['regions'] = array_values($user['regions']);
}

echo json_encode(array_values($arr_out));