<?php
/***
 *  Filer search query endpoint.
 *
 *  Assembles query from fields in the /filer-search form. Driver code taken from voter-lookup script and kept in
 * in anticipation of joining multiple tables in the future.
 *
 */
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

//Initialize
$filerName = $request['filerName'];
$filerID = $request['filerID'];
$treasurerFirstName = $request['treasurerFirstName'];
$treasurerLastName = $request['treasurerLastName'];
$treasurerAddress = $request['treasurerAddress'];
$treasurerCity = $request['treasurerCity'];
$treasurerZipcodeLow = $request['treasurerZipcodeLow'];
$treasurerZipcodeHigh = $request['treasurerZipcodeHigh'];
$isActive = $request['isActive'];
$isInactive = $request['isInactive'];
$filerStatuses = $request['filerStatusSelect'];
$filerTypes = $request['filerTypeSelect'];
$complianceTypes = $request['complianceTypeSelect'];
$committeeTypes = $request['committeeTypeSelect'];
$officeTypes = $request['officeTypeSelect'];
$committeeAddress = $request['committeeAddress'];
$committeeCity = $request['committeeCity'];
$committeeZipcodeLow = $request['committeeZipcodeLow'];
$committeeZipcodeHigh = $request['committeeZipcodeHigh'];
$counties = $request['counties'];
$limit = $request['limit'];
$action = $request['action'];

//Assemble Query Section
$arrSql = array();
$driver = array();
$table = array('fd' => 'filer_data');


if (trim($limit) == '' || (int)trim($limit) > 10000) {
    $limit = '10000';
    $limitSet = false;
} else {
    $limitSet = true;
}

if($filerStatuses) {

    $filerStatusArray = [];

    foreach( $filerStatuses as $val) {
        array_push($filerStatusArray,$val);
    }

    $filerStatuses = $filerStatusArray;

    $statAll = implode("','", $filerStatuses);
    $arrSql['fd'][] = "filer_status in ('" . strtoupper($statAll) . "')";

}

if($filerTypes) {

    $filerTypesArray = [];
    
    foreach($filerTypes as $val) {
        array_push($filerTypesArray,$val);
    }

    $filerTypes = $filerTypesArray;

    $typeAll = implode("','", $filerTypes);
    $arrSql['fd'][] = "filer_type in ('" . strtoupper($typeAll) . "')";

}

if($complianceTypes) {

    $complianceTypesArray = [];
    
    foreach($complianceTypes as $val) {
        array_push($complianceTypesArray,$val);
    }

    $complianceTypes = $complianceTypesArray;

    $compAll = implode("','", $complianceTypes);
    $arrSql['fd'][] = "compliance_type in ('" . strtoupper($compAll) . "')";

}

if($committeeTypes) {

    $committeeTypesArray = [];
    
    foreach($committeeTypes as $val) {
        array_push($committeeTypesArray,$val);
    }

    $committeeTypes = $committeeTypesArray;

    $commAll = implode("','", $committeeTypes);
    $arrSql['nct'][] = "committee_id in ('" . strtoupper($commAll) . "')";

}

if($counties) {

    $countiesArray = [];

    foreach($counties as $val) {
        array_push($countiesArray,$val);
    }

    $counties = $countiesArray;

    $countiesAll = implode("','", $counties);
    $arrSql['na'][] = "(fd.county_desc in ('" . strtoupper($countiesAll) . "') OR nzc.county_name in ('". strtoupper($countiesAll) ."'))";

}

if($officeTypes) {

    $officeTypesArray = [];
    
    foreach($officeTypes as $val) {
        $key = str_replace("'", '',$val);
        $key = explode( ',', $key);
        array_push($officeTypesArray,$key);
    }

    $officeTypes = array_merge([], ...$officeTypesArray);

    $offAll = implode("','", $officeTypes);
    $arrSql['nfo'][] = "office_id in ('" . strtoupper($offAll) . "')";

}

if (trim($filerName) > '') {
    $arrSql['fd'][] = "filer_name like '%" . strtoupper(trim($filerName)) ."%'";
}

if (trim($filerID) > '') {
    $arrSql['na'][] = "(fd.filer_id like '" . strtoupper(trim($filerID)) ."' OR fd2.filer_id like '" . strtoupper(trim($filerID)) ."')";
}

if (trim($treasurerFirstName) > '') {
    $arrSql['fd'][] = "treasurer_first_name like '" . strtoupper(trim($treasurerFirstName)) . "'";
}

if (trim($treasurerLastName) > '') {
    $arrSql['fd'][] = "treasurer_last_name like '" . strtoupper(trim($treasurerLastName)) . "'";
}

if (trim($treasurerAddress) > '') {
    $arrSql['fd'][] = "treasurer_address like '" . strtoupper(trim($treasurerAddress)) . "'";
}

if (trim($treasurerCity) > '') {
    $arrSql['fd'][] = "treasurer_city like '" . strtoupper(trim($treasurerCity)) . "'";
}

if(trim($treasurerZipcodeLow) > '' || trim($treasurerZipcodeHigh)) {

    if(trim($treasurerZipcodeLow) > '' && trim($treasurerZipcodeHigh) > '') {
        $arrSql['fd'][] = "treasurer_zip >= '" . (int)trim($treasurerZipcodeLow)."'";
        $arrSql['fd'][] = "treasurer_zip <= '" . (int)trim($treasurerZipcodeHigh)."'";
    } elseif(trim($treasurerZipcodeLow) > '') {
        $arrSql['fd'][] = "treasurer_zip >= '" . (int)trim($treasurerZipcodeLow)."'";
    } elseif(trim($treasurerZipcodeHigh) > '') {
        $arrSql['fd'][] = "treasurer_zip <= ." . (int)trim($treasurerZipcodeHigh)."'";
    }

}

//Because of the way the table is joined with each other for the candidate -> committee mapping
//we search over the same fields but on the other side of the join for the committee details.

if (trim($committeeAddress) > '') {
    $arrSql['na'][] = "(fd.treasurer_address like '" . strtoupper(trim($committeeAddress)) . "' OR fd2.treasurer_address like '" . strtoupper(trim($committeeAddress)) . "')";
}

if (trim($committeeCity) > '') {
    $arrSql['na'][] = "(fd.treasurer_city like '" . strtoupper(trim($committeeCity)) . "' OR fd.treasurer_city like '" . strtoupper(trim($committeeCity)) . "')";
}

if(trim($committeeZipcodeLow) > '' || trim($committeeZipcodeHigh)) {

    if(trim($committeeZipcodeLow) > '' && trim($committeeZipcodeHigh) > '') {
        $arrSql['na'][] = "treasurer_zip >= '" . (int)trim($committeeZipcodeLow)."'";
        $arrSql['na'][] = "treasurer_zip <= '" . (int)trim($committeeZipcodeHigh)."'";
    } elseif(trim($committeeZipcodeLow) > '') {
        $arrSql['na'][] = "treasurer_zip >= '" . (int)trim($committeeZipcodeLow)."'";
    } elseif(trim($committeeZipcodeHigh) > '') {
        $arrSql['na'][] = "treasurer_zip <= ." . (int)trim($committeeZipcodeHigh)."'";
    }

}


$driverKey = key($driver);
$q = "";

if(count($arrSql)){
    $q .= " WHERE ";

    foreach ($arrSql as $k => $v) {

        if($v) {

            $lastKey = array_key_last($arrSql);

                $tmp = array();
                foreach ($v as $a) {

                    //If it's not the one key reserved for hard-coded table prefixes, add a prefix.
                    if($k !== 'na') {
                        $tmp[] = $k . "." . $a;
                    }
                    else {
                        $tmp[] = $a;
                    }
                }

                //If there's one or less elements in the array, join them correctly
                $last = array_pop($tmp);
                if ($tmp) {
                    $q .= implode(' AND ', $tmp) . " AND " . $last;
                } else {
                    $q .= " AND " . $last;
                }

//            // If this isn't the last key, join to the next array statement
//            if($k != $lastKey) {
//                $q .= " AND ";
//            }

        }
    }

}


// Connect to donor database
$db = db_conn('@nxsidx_ny');


$sqlAll = "SELECT fd.id, fd.filer_id AS filer_id, fd.filer_name AS committee_name, fd.compliance_type AS compliance_type,
                  fd.filer_type AS filer_type, fd.filer_status AS filer_status, fd.committee_type AS committee_type,
                  fd.office_desc AS committee_office, fd.district AS committee_district, fd.county_desc AS committee_county,
                  fd.municipality_desc AS committee_municipality, fd.treasurer_first_name AS treasurer_first_name,
                  fd.treasurer_middle_name AS treasurer_middle_name, fd.treasurer_last_name AS treasurer_last_name,
                  fd.treasurer_address AS treasurer_address, fd.treasurer_city AS treasurer_city,
                  fd.treasurer_state AS treasurer_state, fd.treasurer_zip AS treasurer_zip, fd2.filer_id AS candidate_id,
                  fd2.filer_name AS candidate_name, fd2.compliance_type AS cand_compliance_type, fd2.filer_type AS filer_type,
                  fd2.filer_status AS filer_status, fd2.committee_type AS cand_committee_Type, fd2.office_desc AS candidate_office,
                  fd2.district AS candidate_district, fd2.county_desc AS candidate_county,
                  fd2.municipality_desc AS candidate_municipality, fd2.treasurer_first_name AS representative_fname,
                  fd2.treasurer_middle_name AS representative_mname, fd2.treasurer_last_name AS representative_lname,
                  fd2.treasurer_address AS committee_address, fd2.treasurer_city AS committee_city,
                  fd2.treasurer_state AS committee_state, fd2.treasurer_zip AS committee_zip
           FROM nxsidx_ny.nys_filer_data fd
                    JOIN nxsidx_ny.nys_filer_data_previous_id pd
                         ON (fd.filer_id = pd.filer_id)
                    LEFT JOIN (SELECT committee_id AS filer_key, candidate_id AS filer_value
                               FROM nys_filer_map fd1
                               UNION ALL
                               SELECT candidate_id AS filer_key, committee_id AS filer_value
                               FROM nys_filer_map fd2) fmap ON fd.filer_id = fmap.filer_key
                    LEFT JOIN nys_filer_data fd2 ON fd2.filer_id = fmap.filer_value
                    LEFT JOIN nxsidx_ny.nys_zip_codes nzc on fd2.treasurer_zip = nzc.zip
                    LEFT JOIN nxsidx_ny.nys_filer_offices nfo on fd2.office_desc = nfo.office_name
                    LEFT JOIN nxsidx_ny.nys_committee_types nct on fd.committee_type = nct.committee_type

";

if ($q) {
    $sqlAll .= $q;
}


// Order by filer name
$sqlAll .= " ORDER BY fd.filer_name;";



//Execute Query Section
$stmtAll = $db->Prepare($sqlAll);

try {
    $rsAll = $db->Execute($stmtAll);
} catch (ADODB_Exception $e) {
    $db->disconnect();
    die(dbErr($e->getMessage()));
}

error_log(print_r($stmtAll,true));


// We're skipping making another query for the recordcount and letting the result set answer that.
$arrCount= $rsAll->recordCount();
$arrAll = $rsAll->GetArray();
switch ($action) {
    case 'query':
        $db->disconnect();
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
