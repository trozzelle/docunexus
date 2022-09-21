<?php
error_reporting(E_ERROR | E_PARSE);
$conf = json_decode(file_get_contents($_SERVER['DOCUMENT_ROOT'].'/../conf/config.json'), true);
define("HASH", $conf['php']['hash']);
define("EMAILPASS", $conf['php']['email_password']);
define("DB_CONF", $conf['db']);
require_once($_SERVER['DOCUMENT_ROOT'].'/vendor/adodb/adodb-php/adodb-errorpear.inc.php');
require_once($_SERVER['DOCUMENT_ROOT'].'/vendor/adodb/adodb-php/adodb.inc.php');
function check_token($params) {
	return array();
    /*$p = json_decode($params[0]);
    $out = array();
    if (!$p->userid) {
        $out = ['tokenerror' => true, 'message' => "No authentication user ID provided"];
    } else if (!$p->token) {
        $out = ['tokenerror' => true, 'message' => "No authentication user token provided"];
    } else {        
        $db = db_conn('@dcnxs_app');
        $sql = "SELECT u.auth_token, u.auth_token_expires FROM dcnxs_app.users u WHERE u.userid = ".$p->userid;
        $stmt = $db->Prepare($sql);
        try {
            $rs = $db->Execute($sql);
        } catch (ADODB_Exception $e) {
            $db->disconnect();
            die(dbErr($e->getMessage()));
        }
        pearErr($db, ADODB_PEAR_Error());
        $arr = $rs->GetArray();    
        $db->disconnect();
        //Invalid user
        if (!$arr[0]['auth_token'] || !count($arr)) {
            $out = ['tokenerroror' => true, 'message' => "No authorization token available"];        
        }
        //Auth token doesn't match
        if ($arr[0]['auth_token'] != $p->token) {
            $out = ['tokenerror' => true, 'message' => "Authorization token mismatch"];        
        }
        //Session expired
        $expFormat = mktime(date("H"), date("i"), date("s"), date("m") ,date("d"), date("Y"));
        $expDate = date($expFormat);
        if ($expDate > $arr[0]['auth_token_expires']) {
            $out = ['tokenerror' => true, 'message' => "Your session has expired"];
        }
    }
    return $out;*/
}

function db_conn($schema = NULL) {    
	switch ($schema) {
        case '@nxsidx_ny':
			$dbase = 'nxsidx_ny';
			$user = 'nxsidx_ny';
			$pass = DB_CONF['passwords']['nxsidx_ny'];
			$host = DB_CONF['host'];
			$type = 'mysql';
        break;
		case '@nxsidx_app':
			$dbase = 'nxsidx_app';
			$user = 'nxsidx_app';
			$pass = DB_CONF['passwords']['nxsidx_app'];
			$host = DB_CONF['host'];
			$type = 'mysql';
        break;
		case '@nxsidx_lists':
			$dbase = 'nxsidx_user_lists';
			$user = 'nxsidx_user_lists';
			$pass = DB_CONF['passwords']['nxsidx_user_lists'];
			$host = DB_CONF['host'];
			$type = 'mysql';
        break;		
        case '@dcnxs_app':
			$dbase = 'dcnxs_app';
			$user = 'dcnxs_app';
			$pass = DB_CONF['passwords']['dcnxs_app'];
			$host = DB_CONF['host'];
			$type = 'mysql';
		break;	
		case '@dcnxs_ny':
			$dbase = 'dcnxs_ny';
			$user = 'dcnxs_app';
			$pass = DB_CONF['passwords']['dcnxs_app'];
			$host = DB_CONF['host'];
			$type = 'mysql';
        break;	
		default:
			$db = '';
			$tns = '';
			$user = '';
			$pass = '';
			$host = '';
            $type = '';
	}
	
	switch ($type) {
		case 'mysql':
			$db = ADONewConnection('mysqli');
			$db->SetFetchMode(ADODB_FETCH_ASSOC);
			$db->NConnect($host, $user, $pass, $dbase);
		break;
	}
	if (false == $db) { 
		die("Database connection error"); 
	}
	return $db;
}

function oraEscape($s) {
	$tmp = $s;
	$tmp = str_replace("'", "''", $tmp);
	$tmp = str_replace('"', '', $tmp);
    $tmp = str_replace('&quot;', '', $tmp);
	$tmp = str_replace("&", "and", $tmp);   
    $tmp = str_replace(array("\n", "\r", "\r\n", "\n\r"), ' ', $tmp);
	$tmp = trim($tmp);
	return $tmp;
}

function dbErr($error) {
    return json_encode(array('error' => $error));
}

function pearErr($db, $err) {
	if ($err->code) {
		$db->disconnect();
		//print_r($err);
		die('{"error": "'.trim(preg_replace('/\s+/', ' ', preg_replace("/\"/", "", $err->userinfo))).'"}');
	}
}