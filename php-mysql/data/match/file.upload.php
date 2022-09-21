<?php
error_reporting(E_ALL & ~E_NOTICE);
ini_set("display_errors", 1);

require_once ($_SERVER['DOCUMENT_ROOT'] . '/db.config.php');
require_once ($_SERVER['DOCUMENT_ROOT'] . '/functions.php');

//Check user authentication token
$t = json_decode($_REQUEST['token']);
$token[] = json_encode($t[0]);  
$arr_token = check_token($token);
if (count($arr_token)) { die(json_encode($arr_token)); }

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
	
    //$mimes = array('application/vnd.ms-excel','text/plain','text/csv','text/tsv');
    //if (!in_array($_FILES['file']['type'], $mimes)) {
    //    throw new RuntimeException('Invalid mimetype: '.$_FILES['file']['type']);
    //}
	
} catch (RuntimeException $e) {
    die(sprintf('{"error": "%s"}',  $e->getMessage()));
}


//The file was uploaded ok, add it to the database and return the HISTORY_SEQUENCE value back to the app, as well as the first five rows for mapping
$file = file_get_contents($_FILES['file']['tmp_name']);
$filename = $_FILES['file']['name'];
$seq = 0;

parseFilePreview($filename, $file, $seq, array());
die();