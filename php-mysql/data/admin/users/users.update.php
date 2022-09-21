<?php 
error_reporting(E_ALL & ~E_NOTICE);
ini_set("display_errors", 1);
require_once ($_SERVER['DOCUMENT_ROOT'] . '/db.config.php');

//Check user authentication token
$t = json_decode($_REQUEST['token']);
$token[] = json_encode($t[0]);  
$arr_token = check_token($token);
if (count($arr_token)) { die(json_encode($arr_token)); }

$data = $_REQUEST['data'];
$query = json_decode($data);

$arr_expr = array();
$arr_field = array();
$arr_value = array();

function updateMembership($query, $userid) {
    $db = db_conn('@dcnxs_app');
    if (is_array($query->groups)) {                   
        //Delete group membership for user
        $sql = "DELETE FROM dcnxs_app.user_groups WHERE userid = ?";
        $stmtParams = array($userid);
        $stmt = $db->Prepare($sql);
        $db->Execute($stmt, $stmtParams);
        //Add group membership
        unset($sql);
        unset($stmt);
        if (count($query->groups)) {
            $g = array();
            $sql = "INSERT INTO dcnxs_app.user_groups (userid, groupid, group_admin) VALUES ";            
            unset($stmtParams);
            $stmtParams = array();            
            foreach ($query->groups as $group) {
                $stmtParams[] = $userid;
                $stmtParams[] = $group->groupid;
                $stmtParams[] = $group->group_admin;
                $g[] = "(?,?,?)";
            }        
            $sql .= implode(",", $g);                                                                    
            $stmt = $db->Prepare($sql);        
            try {
                $db->Execute($stmt, $stmtParams);
            } catch (ADODB_Exception $e) {
                $db->disconnect();
                die(dbErr($e->getMessage()));
            }        
            pearErr($db, ADODB_PEAR_Error());
        }
    }
    if (is_array($query->regions)) {        
        //Delete region membership for user    
        $sql = "DELETE FROM dcnxs_app.user_regions WHERE userid = ?";
        $stmtParams = array($userid);
        $stmt = $db->Prepare($sql);
        $db->Execute($stmt, $stmtParams);        
        //Add region membership
        unset($sql);
        unset($stmt);        
        if (count($query->regions)) {
            $r = array();
            $sql = "INSERT INTO dcnxs_app.user_regions (userid, regionid, region_admin) VALUES ";            
            unset($stmtParams);
            $stmtParams = array();            
            foreach ($query->regions as $region) {
                $stmtParams[] = $userid;
                $stmtParams[] = $region->regionid;
                $stmtParams[] = $region->region_admin;
                $r[] = "(?,?,?)";
            }        
            $sql .= implode(",", $r);                                  
            $stmt = $db->Prepare($sql);        
            try {
                $db->Execute($stmt, $stmtParams);
            } catch (ADODB_Exception $e) {
                $db->disconnect();
                die(dbErr($e->getMessage()));
            }        
            pearErr($db, ADODB_PEAR_Error());
        }
    }
    $db->disconnect();
}

$db = db_conn('@dcnxs_app');

switch ($query->action) {
    case 'update':
        $stmtParams = array();
        foreach ($query as $k => $v) {
            if ($k != 'userid' && $k != 'action' && $k != 'groups' && $k != 'regions') {
                if ($k == 'password') { 
                    $stmtParams[] = hash('sha512', HASH.$v);                           
                } else {
                    $stmtParams[] = $v;                    
                }
                $arr_expr[] = $k . " = ?";
            }
        }
        if (count($arr_expr)> 0) {
            $stmtParams[] = $query->userid;
            $sql = "UPDATE dcnxs_app.users SET " . implode($arr_expr, ", ") . " WHERE userid = ?";                                   
            $stmt = $db->Prepare($sql);
            try {
                $db->Execute($stmt, $stmtParams);
            } catch (ADODB_Exception $e) {
                $db->disconnect();
                die(dbErr($e->getMessage()));
            }
            pearErr($db, ADODB_PEAR_Error());     
        }
        $db->disconnect();
        updateMembership($query, $query->userid);        
    break;
    case 'add':
        $in_email = $query->email;
        $in_display_name = $query->display_name;
        $in_password = hash('sha512', HASH.$query->password);
        $in_site_admin = $query->site_admin;
        $in_enabled = $query->enabled;
        $in_username = $query->username;    
        $sql = "CALL dcnxs_app.add_user(?,?,?,?,?,?);";
        $stmt = $db->Prepare($sql);
        $stmtParams = array($in_email, $in_display_name, $in_password, $in_site_admin, $in_enabled, $in_username);
        try {
            $rs = $db->Execute($stmt, $stmtParams);
        } catch (ADODB_Exception $e) {
            $db->disconnect();
            die(dbErr($e->getMessage()));
        }
        pearErr($db, ADODB_PEAR_Error());
        
        $arr = $rs->GetArray();
        $db->disconnect();  
        updateMembership($query, $arr[0]['userid']);        
        echo json_encode($arr);
    break;
    case 'delete':        
        $sql = "CALL dcnxs_app.delete_user(?);";
        $stmtParams = array($query->userid);
        $stmt = $db->Prepare($sql);
        try {
            $rs = $db->Execute($stmt, $stmtParams);
        } catch (ADODB_Exception $e) {
            $db->disconnect();
            die(dbErr($e->getMessage()));
        }
        pearErr($db, ADODB_PEAR_Error());
        $db->disconnect();
    break;
}