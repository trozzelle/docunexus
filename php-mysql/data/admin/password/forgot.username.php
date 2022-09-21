<?php
error_reporting(E_ALL & ~E_NOTICE);
ini_set("display_errors", 1);
require_once ($_SERVER['DOCUMENT_ROOT'] . '/db.config.php');
require_once ($_SERVER['DOCUMENT_ROOT'] . '/vendor/autoload.php');
use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;

$email = $_REQUEST['email'];
if (!$email) {
    die('{"status": "error", "data": "You must provide an email address."}');
}
$sql = "SELECT userid, email, display_name, username FROM dcnxs_app.users where email = ?";
$db = db_conn('@dcnxs_app');

$stmtParams = array($email);
$stmt = $db->Prepare($sql);

try {
	$rs = $db->Execute($stmt, $stmtParams);
} catch (ADODB_Exception $e) {
	$db->disconnect();
    die(dbErr($e->getMessage()));    
}
pearErr($db, ADODB_PEAR_Error());
$db->disconnect();
$arr = $rs->GetArray();

if (count($arr) > 0) { //Email exists  
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
        $mail->Subject  =  'Docunexus username';
        $mail->IsHTML(true);
        $mail->Body = "<p style='font-size: 18px; font-weight: bold'>Hi ".$arr[0]['display_name'].",</p>";
        $mail->Body .= "<p>Your username for the Docunexus website is below:</p>";
        $mail->Body .= "<p><strong>".$arr[0]['username']."</strong></p>";
        $mail->Body .= "<p>Log in to the site by clicking <a href='//docunexus.net' target='_blank'>this link</a>.</p>";        
        $mail->Body .= "<p>Thanks,</p>";
        $mail->Body .= "<p>The Docunexus team</p>";        
        if($mail->Send()) {
            die('{"status": "success", "data": "An email containing your username has been sent to the address on file."}');
        } else {
            die('{"status": "error", "data": "The username email could not be sent."}');
        }
    } catch (phpmailerException $e) {
        die('{"status": "error", "data": ".$e->getMessage()."}');
    }
} else { //Email does not exist    
    $db->disconnect();
    die('{"status": "warning", "data": "The email address provided does not exist in the system."}');
}
exit();