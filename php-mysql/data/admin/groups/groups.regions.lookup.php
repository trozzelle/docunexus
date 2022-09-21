<?php
error_reporting(E_ALL & ~E_NOTICE);
ini_set("display_errors", 1);
//Database configuration
require_once ($_SERVER['DOCUMENT_ROOT'] . '/db.config.php');

//Check user authentication token
$arr_token = check_token($_REQUEST['token']);
if (count($arr_token)) { die(json_encode($arr_token)); }

$sql = "SELECT 
g.groupid,
g.group_name,
g.group_image,
r.region_name,
r.regionid
FROM
dcnxs_app.groups g
	LEFT JOIN
dcnxs_app.group_regions gr ON (gr.groupid = g.groupid)
	LEFT JOIN
dcnxs_app.regions r ON (r.regionid = gr.regionid)
ORDER BY g.groupid";

$db = db_conn('@dcnxs_app');
$stmt = $db->Prepare($sql);
try {
	$rs = $db->Execute($stmt);
} catch (ADODB_Exception $e) {
	$db->disconnect();
    die(dbErr($e->getMessage()));    
}
pearErr($db, ADODB_PEAR_Error());
$db->disconnect();
$arr = $rs->GetArray();
$gid = '';
$arr_out = array();
foreach ($arr as $a) {
	if ($a['groupid'] != $gid) {
		$gid = $a['groupid'];
		$arr_out[$gid] = array(
			'groupid' => $a['groupid'],
			'group_name' => $a['group_name'],
            'group_image' => $a['group_image'],
			'regions' => array()
		);		
	}
	if ($a['regionid']) {
		$arr_out[$gid]['regions'][] = array('regionid' => $a['regionid'], 'region_name' => $a['region_name']);
	}
}
echo json_encode(array_values($arr_out));