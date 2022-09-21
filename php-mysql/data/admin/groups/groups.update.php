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

$groupid = $_REQUEST['groupid'];
$group_name = $_REQUEST['group_name'];
$group_image = $_REQUEST['group_image'];
$action = $_REQUEST['action'];
$regionids = explode(",", $_REQUEST['regionids']);

if ($_FILES['file']) {
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
        
    } catch (RuntimeException $e) {
        die(sprintf('{"error": "%s"}',  $e->getMessage()));
    }
    //The file was uploaded ok, add it to the database and return the HISTORY_SEQUENCE value back to the app, as well as the first five rows for mapping
    $file = 'data:'.$_FILES['file']['type'].';base64,'.base64_encode(file_get_contents($_FILES['file']['tmp_name']));
} else {
    $file = '';
}

switch($action) {
    case 'add':
        $stmtParams = array($group_name, $file);
        $sql = "CALL dcnxs_app.add_group(?, ?);";      
    break;
    case 'update':
        $stmtParams = array($groupid, $group_name, $file);
        $sql = "CALL dcnxs_app.update_group(?, ?, ?);";
        if (count($regionids) > 0) {
            $stmtregionsParams = array();
            $sqlregions = "INSERT INTO dcnxs_app.group_regions (groupid, regionid) VALUES ";
            foreach ($regionids as $r) {
                $stmtregionsParams[] = $groupid;
                $stmtregionsParams[] = $r;
                $sqlregions .= "(?,?),";
            }
            $sqlregions = rtrim($sqlregions, ",");            
        }
    break;
    case 'delete':
        $stmtParams = array($groupid);
        $sql = "CALL dcnxs_app.delete_group(?);"; 
    break;
    default:
        die('{"error": "Invalid group action provided"}');
    break;
}

$db = db_conn('@dcnxs_app');
$stmt = $db->Prepare($sql);
try {
    $rs = $db->Execute($stmt, $stmtParams);
} catch (ADODB_Exception $e) {
    $db->disconnect();
    die(dbErr($e->getMessage()));  
}
pearErr($db, ADODB_PEAR_Error());
$db->disconnect();
//Update group regions
if ($action == 'update' && count($regionids) > 0) {
    $db = db_conn('@dcnxs_app');
    unset($stmt);
    $stmt = $db->Prepare($sqlregions);
    try {
        $db->Execute($stmt, $stmtregionsParams);
    } catch (ADODB_Exception $e) {
        $db->disconnect();
        die(dbErr($e->getMessage()));  
    }
    pearErr($db, ADODB_PEAR_Error());
    $db->disconnect();
}
$arr = $rs->GetArray();
echo json_encode($arr);