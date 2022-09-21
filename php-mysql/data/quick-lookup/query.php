<?php 
ini_set('memory_limit', '768M');
ini_set('max_execution_time', 6000);
ini_set('max_input_time', 6000);
set_time_limit(0);

error_reporting(E_ALL & ~E_NOTICE);
ini_set('display_errors', TRUE); 
ini_set('display_startup_errors', TRUE); 

require_once ($_SERVER['DOCUMENT_ROOT'] . '/db.config.php');

$r = $_REQUEST;    
$token = $_REQUEST['token'];
$request = (array)json_decode($r['query']);
if ($request['action'] == 'download') {
    $token = array();
    $t = json_decode($r['token']);
    $token[] = json_encode($t[0]);    
}

//Check user authentication token
$arr_token = check_token($token);
if (count($arr_token)) { die(json_encode($arr_token)); }

$lastName = $request['lastName'];
$firstName = $request['firstName'];
$middleName = $request['middleName'];
$suffix = $request['suffix'];
$residenceNum = $request['residenceNum'];
$residenceStreet = $request['residenceStreet'];
$residenceCity = $request['residenceCity'];
$zipcode = $request['zipcode'];
$ageRange = $request['ageRange'];
$ageStart = $request['ageStart'];
$ageEnd = $request['ageEnd'];
$gender = $request['gender'];
$county = $request['county'];
$electionDistrict = $request['electionDistrict'];
$congressionalDistrict = $request['congressionalDistrict'];
$senateDistrict = $request['senateDistrict'];
$legislativeDistrict = $request['legislativeDistrict'];
$assemblyRep = $request['assemblyRep'];
$congressionalRep = $request['congressionalRep'];
$senateRep = $request['senateRep'];
$enrollment = $request['enrollment'];
$assemblyDistrict = $request['assemblyDistrict'];
$hasTelephone = $request['hasTelephone'];
$hasEmail = $request['hasEmail'];
$voteStart = $request['voteStart'];
$voteEnd = $request['voteEnd'];
$voteIncludeCount = $request['voteIncludeCount'];
$limit = $request['limit'];
$random = $request['random'];
$action = $request['action'];

if (trim($limit) == '' || intval(trim($limit)) > 10000) {
    $limit = '10000';
    $limitSet = false;
} else {
    $limitSet = true;
}

$arrSql = array();

if (trim($voteStart) > '') {
    if (trim($voteEnd) == '') {
        $voteEnd = date("Y");
    }    
}
$driver = array();
$table = array('vd' => 'voter_data');

if (trim($lastName) > '' || trim($firstName) > '') {
    $table['vl'] = 'voter_name_part';
    $driver['vl'] = 'voter_name_part'; 
    if (trim($lastName) > '' && trim($firstName) > '') {
        $arrSql['vl'] = $arrSql['vl'] = "first_name = '" . strtoupper(trim($firstName)) ."' AND vl.last_name = '" . strtoupper(trim($lastName)) ."'";
    } else {
        if (trim($lastName) > '') {   
            $arrSql['vl'] = $arrSql['vl'] = "last_name = '" . strtoupper(trim($lastName)) ."'";
        }
        if (trim($firstName) > '') {   
            $arrSql['vl'] = "first_name = '" . strtoupper(trim($lastName)) ."'";
        }
    }
}
if (trim($middleName) > '') {
    $arrSql['vd'][] = "middle_name = '" . strtoupper(trim($middleName)) ."'";
}
if (trim($suffix) > '') {
    $arrSql['vd'][] = "name_suffix = '" . strtoupper(trim($suffix)) ."'";
}
if (trim($residenceNum) > '') {
    $arrSql['vd'][] = "residence_num = '" . trim($residenceNum) ."'";
}
if (trim($residenceStreet) > '') {
    $table['vs'] = 'voter_street_name';
    if (!count($driver)) {
        $driver['vs'] = 'voter_street_name';
    }    
    $arrSql['vs'] = "residence_street_name = '" . strtoupper(trim($residenceStreet)) ."'";
}
if (trim($residenceCity) > '') {
    $table['vc'] = 'voter_city';
    if (!count($driver)) {
        $driver['vc'] = 'voter_city';
    }    
    $arrSql['vc'] = "residence_city = '" . strtoupper(trim($residenceCity)) ."'";
}
if (trim($county) > '') {
    $arrSql['vd'][] = "county_code = '" . $county ."'";
}


if ($hasEmail == 'true') {
    $arrSql['vd'][] = "email > ''";
}

if ($hasTelephone == 'true') {
    $arrSql['vd'][] = "telephone > ''";
}

if (is_array($gender) && count($gender)) {
    if (in_array('U', $gender)) {
        $gender[] = '';
    }
    $g = implode("','", $gender);
    $arrSql['vd'][] = "gender IN ('" . $g . "')";
}

if (trim($zipcode) > '') {
    $table['z5'] = 'voter_zip5';
    if (!count($driver)) {
        $driver['z5'] = 'voter_zip5';
    }    
    if (strlen(trim($zipcode)) > 5) {
        $arrZip = explode('-', trim($zipcode));
        if (strlen($arrZip[1]) == 4) {
            $arrSql['vd'][] = "residence_zip_4 = '" . $arrZip[1];
        }
        $arrSql['z5'] = "zip5 = '" . substr(trim($zipcode), 0, 5) ."'";
    } else {
        $arrSql['z5'] = "zip5 = '" . trim($zipcode) ."'";
    }    
}


$startAge = date('Ymd', strtotime('-'.$ageStart.' year'));
$endAge = date('Ymd', strtotime('-'.$ageEnd.' year'));

switch ($ageRange) {
    case 'older':
        $arrSql['vd'][] = "date_of_birth <= '" . $startAge ."'";
    break;
    case 'younger':
        $arrSql['vd'][] = "date_of_birth >= '" . $startAge ."'";
    break;
    case 'between':
        $arrSql['vd'][] = "date_of_birth BETWEEN '" . $endAge . "' AND '" . $startAge ."'";
    break;
}

if (trim($electionDistrict) > '') {
    $arrSql['vd'][] = "election_district IN (" . trim($electionDistrict) . ")";
}
if (trim($congressionalDistrict) > '') {
    $arrSql['vd'][] = "congressional_district IN (" . trim($congressionalDistrict) . ")";
}
if (trim($senateDistrict) > '') {
    $arrSql['vd'][] = "senate_district IN (" . trim($senateDistrict) . ")";
}
if (trim($legislativeDistrict) > '') {
    $arrSql['vd'][] = "legislative_district IN (" . trim($legislativeDistrict) . ")";
}
if (trim($assemblyDistrict) > '') {
    $arrSql['vd'][] = "assembly_district IN (" . trim($assemblyDistrict) . ")";
}

if (is_array($congressionalRep) && count($congressionalRep)) {
    $y = implode("','", $congressionalRep);
    $arrSql['vd'][] = "congressional_district IN ('" . $y . "')";
}

if (is_array($assemblyRep) && count($assemblyRep)) {
    $y = implode("','", $assemblyRep);
    $arrSql['vd'][] = "assembly_district IN ('" . $y . "')";
}

if (is_array($senateRep) && count($senateRep)) {
    $y = implode("','", $senateRep);
    $arrSql['vd'][] = "senate_district IN ('" . $y . "')";
}

if (is_array($enrollment) && count($enrollment)) {
    $y = implode("','", $enrollment);
    $arrSql['vd'][] = "enrollment IN ('" . $y . "')";
}

if (is_array($electionYearsInclude) && count($electionYearsInclude)) {
    $y = implode("','", $electionYearsInclude);
    $arrEY[] = "vh.election_year IN ('" . $y . "')";
}

if (is_array($electionYearsExclude) && count($electionYearsExclude)) {
    $y = implode("','", $electionYearsExclude);
    $arrEY[] = "vh.election_year NOT IN ('" . $y . "')";
}

if (!count($driver)) {
    $driver['vd'] = 'voter_data';
}

$driverKey = key($driver);

$q = "";
foreach ($table as $key => $value) {
    if ($key == 'vd') {        
        continue;
    }
    if ($key == $driverKey) {
        $q .= " JOIN ".$value." ".$key." ON ".$key.".".$arrSql[$key]." AND vd.nys_voter_id = ".$key.".nys_voter_id";
    } else {
        $q .= " JOIN ".$value." ".$key." ON ".$key.".".$arrSql[$key];
        $q .= " AND ".$key.".nys_voter_id = ".$driverKey.".nys_voter_id";
    }    
}

if(count($arrSql['vd'])) {
    $q .= " WHERE ";
    $tmp = array();
    foreach ($arrSql['vd'] as $a) {
        $tmp[] = "vd.".$a;
    }
    $q .= implode(" AND ", $tmp);   
}


$db = db_conn('@dcnxs_ny');

$sqlAll .= "WITH vd AS (SELECT vd.* ";
if (trim($voteStart) > '') {
    $vs = intval(trim($voteStart));
    $ve = intval(trim($voteEnd));
    if ($ve === 0) {
        $ve = 9999;
    }
    if ($vs > $ve) {
        $vs = intval(trim($voteEnd));
        $ve = intval(trim($voteStart));
    }

    $sqlAll .= ", (SELECT COUNT(DISTINCT(el.election_year)) as election_count from voter_history vh
    JOIN elections el on vh.election_name = el.election_name AND el.election_year BETWEEN '".trim($vs)."' and '".trim($ve)."' where vh.nys_voter_id = vd.nys_voter_id) as times_voted ";
}

$sqlAll .= "FROM voter_data vd ";
if (!$q) {
    $sqlAll .= " WHERE vd.voter_status IN ('ACTIVE', 'PREREG') ";
} else {
    $sqlAll .= $q . " AND vd.voter_status IN ('ACTIVE', 'PREREG') ";
}
if (trim($voteIncludeCount) > '' && trim($voteStart) > '') {
    $sqlAll .= "HAVING (times_voted >= ".$voteIncludeCount.") ";
}

if ($limitSet) {
    $sqlCount .= $sqlAll . "LIMIT ".$limit.") SELECT * FROM vd";
} else {
    $sqlCount .= $sqlAll . ") SELECT * FROM vd";
}

if ($action == 'query') {
    $sqlAll .= "LIMIT ".$limit." ";
} else {        
    if ($limitSet) {
        $sqlAll .= "LIMIT ".$limit;
    }
}

$sqlAll .= ") SELECT vd.*, ar.representative as assembly_rep, cr.representative as congressional_rep, sr.representative as senate_rep FROM vd ";
$sqlAll .= "JOIN assembly_rep ar ON ar.assembly_district = vd.assembly_district JOIN congressional_rep cr ON (cr.congressional_district = vd.congressional_district) JOIN senate_rep sr ON (sr.senate_district = vd.senate_district) ";
if ($random[0] == 'Y') {
    $sqlAll .= "ORDER BY RAND()";
} else {
    $sqlAll .= "ORDER BY vd.last_name, vd.first_name";
}

$stmtAll = $db->Prepare($sqlAll);
try {
    $rsAll = $db->Execute($stmtAll);
} catch (ADODB_Exception $e) {
    $db->disconnect();
    die(dbErr($e->getMessage()));
}
pearErr($db, ADODB_PEAR_Error());
$arrAll = $rsAll->GetArray();
switch ($action) {
    case 'query':              
        $stmtCount = $db->Prepare($sqlCount);
        try {
            $rsCount = $db->Execute($stmtCount);
        } catch (ADODB_Exception $e) {
            $db->disconnect();
            die(dbErr($e->getMessage()));
        }
        pearErr($db, ADODB_PEAR_Error());
        $arrCount = array();
        $arrCount[] = array('records' => count($rsCount->getArray()));        
        $db->disconnect();
        //$arr = array($arrCount, $arrAll, base64_encode(HASH.$sqlAll));
        $arr = array($arrCount, $arrAll);
        echo json_encode($arr);
    break;
    case 'download':
        $db->disconnect();
        ob_start();
        $tmpcsv = fopen('php://output', 'w');	        
        foreach ($arrAll as $k => $d) {
            if ($k == 0) {
                $file .= fputcsv($tmpcsv, array_keys($d));    
            }
            $file .= fputcsv($tmpcsv, array_values($d));
        }
        fclose($tmpcsv);
        $filedata = ob_get_contents();        
        ob_end_clean();
        header('Content-Type: text/csv');
        header('Content-Disposition: attachment; filename="quick-lookup-download.csv"');
        header('Content-Transfer-Encoding: binary');
        header('Expires: 0');
        header('Cache-Control: must-revalidate, post-check=0, pre-check=0');
        header('Pragma: public');
        echo $filedata;        
    break;
}
exit();
