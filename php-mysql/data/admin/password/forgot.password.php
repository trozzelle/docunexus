<?php
error_reporting(E_ALL & ~E_NOTICE);
ini_set("display_errors", 1);
require_once ($_SERVER['DOCUMENT_ROOT'] . '/db.config.php');
require_once ($_SERVER['DOCUMENT_ROOT'] . '/vendor/autoload.php');
use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;

$username = $_REQUEST['username'];
if (!$username) {
    die('{"status": "error", "data": "You must provide a username."}');
}
$token = md5($email).rand(10,9999);
$expFormat = mktime(date("H"), date("i"), date("s"), date("m") ,date("d")+1, date("Y"));
$expDate = date($expFormat);

$sql = "SELECT userid, email, display_name FROM dcnxs_app.users where username = ?";
$db = db_conn('@dcnxs_app');

$stmtParams = array($username);
$stmt = $db->Prepare($sql);

try {
	$rs = $db->Execute($stmt, $stmtParams);
} catch (ADODB_Exception $e) {
	$db->disconnect();
    die(dbErr($e->getMessage()));    
}
pearErr($db, ADODB_PEAR_Error());

$arr = $rs->GetArray();

if (count($arr) > 0) { //Email exists
    $sqlupdate = "UPDATE dcnxs_app.users SET reset_link_token = ?, reset_expires = ? WHERE username = ?";
    $updatestmtParams = array($token, $expDate, $username);
    $updatestmt = $db->Prepare($sqlupdate);
    try {
        $db->Execute($updatestmt, $updatestmtParams);
    } catch (ADODB_Exception $e) {
        $db->disconnect();
        die(dbErr($e->getMessage()));    
    }
    pearErr($db, ADODB_PEAR_Error());
    $db->disconnect();
    try {
        $mail = new PHPMailer();   
        //$mail->SMTPDebug  = 2;     
        $mail->IsSMTP(); 
        $mail->SMTPAuth   = TRUE;
        $mail->SMTPSecure = "tls";
        $mail->Port       = 587;
        $mail->Host       = "smtp.gmail.com";
        $mail->Username   = "imperativeny.com";
        $mail->Password   = EMAILPASS;
        $mail->SetFrom("imperativeny.com", "Docunexus");
        $mail->AddReplyTo("no-reply@docunexus.net", "Docunexus");        
        $mail->AddAddress($arr[0]['email'], $arr[0]['display_name']);
        $mail->Subject  =  'Docunexus password reset';
        $mail->IsHTML(true);        
        $mail->Body = "<p style='font-size: 18px; font-weight: bold'>Hi ".$arr[0]['display_name'].",</p>";
        $mail->Body .= "<p>You recently requested to reset your password for your Docunexus account.  Click the link below to reset it.</p>";        
        $mail->Body .= "<p><a href='//docunexus.net/reset-password/".$token."' target='_blank'>Reset my password</a></p>";        
        $mail->Body .= "<p>If you did not request a password reset, you can ignore this email.  This password reset is valid for the next 24 hours.</p>";
        $mail->Body .= "<p>Thanks,</p>";
        $mail->Body .= "<p>The Docunexus team</p>";    
        if($mail->Send()) {
            die('{"status": "success", "data": "An email has been sent to the address on file, click the link the email to reset your password."}');
        } else {
            die('{"status": "error", "data": "The password email could not be sent."}');
        }
    } catch (phpmailerException $e) {
        die('{"status": "error", "data": ".$e->getMessage()."}');
    }
} else { //Email does not exist
    $db->disconnect();
    die('{"status": "warning", "data": "The user name provided does not exist in the system."}');
}
exit();