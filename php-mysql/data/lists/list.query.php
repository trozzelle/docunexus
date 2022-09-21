<?php 
ini_set('memory_limit', '768M');
ini_set('max_execution_time', 600);
require_once ($_SERVER['DOCUMENT_ROOT'] . '/db.config.php');

//Check user authentication token
$t = json_decode($_REQUEST['token']);
$token[] = json_encode($t[0]);  
$arr_token = check_token($token);
if (count($arr_token)) { die(json_encode($arr_token)); }

$data = $_REQUEST['data'];
$source = $_REQUEST['source'];
$action = $_REQUEST['action'];

$listid = $_REQUEST['listid'];
$uid = $_REQUEST['userid'];

/*$listid = '13';
$uid = '9';
$action= 'download';*/

if ($listid && $uid && $action == "download") {
    $stmtParams = array($listid, $uid);    
    $db = db_conn('@dcnxs_ny');
    $sqllist = "SELECT listid, userid, list_name, source, query FROM lists WHERE listid = ? AND userid = ?";
    $stmtlist = $db->Prepare($sqllist);
    try {
        $rslist = $db->Execute($stmtlist, $stmtParams);
    } catch (ADODB_Exception $e) {
        $db->disconnect();
        die(dbErr($e->getMessage()));  
    }
    pearErr($db, ADODB_PEAR_Error());
    $db->disconnect();

    $arrlist = $rslist->GetArray();
    $data = $arrlist[0]['query'];
    $source = $arrlist[0]['source'];    
}

//$action = "download";


//$source = 'dcnxs_ny.1_3_match';


$t = explode(".", $source);
$schema = $t[0];
$table = $t[1];
$tmp = explode("_", $table);
$userid = $tmp[0];
$matchid = $tmp[1];
$filename = $source.'-download.csv';

if (count($data)) {
    $query = json_decode($data);   

    //Sort the incoming query objects by alias to put them in the query in the right order
    usort($query, fn($a, $b) => strcmp($a->alias, $b->alias));

    $queryArray = [];
    $tmpStr = '';
    $tmpVal = [];
    $yv = false;    
    foreach ($query as $k => $q) {     
        $field = $q->field;
        if ($q->overrideField > '') {
            $field = $q->overrideField;
        }    
        if ($q->field == 'year_voted') { //Skip year_voted, handle this in a join
            $yv = $q;
        } else {
            //Remove empty values if they exist
            foreach ($q->value as $v) {
                if (trim($v) > '') {
                    $tmpVal[] = $v;
                }
            }            
            //Make a string of values
            $value = implode($tmpVal, "','");
            $tmpVal = [];                         
            switch ($q->operator) {
                case 'LIKE':
                case 'NOT LIKE':
                    $tmpStr .= "UPPER(" . $q->alias . ".`" . $field . "`) " . $q->operator . " ('%" . strtoupper($value) . "%')";                                   
                break;
                case 'IS NULL':
                    $tmpStr .= "TRIM(IFNULL(".$q->alias . ".`" . $field . "`, '')) == ''";
                break;
                case 'IS NOT NULL':
                    $tmpStr .= "TRIM(IFNULL(".$q->alias . ".`" . $field . "`, '')) > ''";
                break;
                case 'BETWEEN': 
                    $tmpStr .= "UPPER(" . $q->alias . ".`" . $field . "`) BETWEEN ('".strtoupper($q->value[0])."') AND ('".strtoupper($q->value[1])."')";
                break;
                default: 
                    $tmpStr .= "UPPER(" . $q->alias . ".`" . $field . "`) " . $q->operator . " ('" . strtoupper($value) . "')";
                break;
            }

            if ($k < count($query) - 1) { //Add logic operators for all but the last element
                $tmpStr .= " " . $q->lop . " ";
            }
            $queryArray[] = $tmpStr;
            $tmpStr = '';
        }
    }
}


$tmpSql = "FROM ".$source." a 
    LEFT JOIN match_data md 
    ON (md.queueid = a.queueid and md.userid = " . $userid . " and md.matchid = " . $matchid . ") 
    LEFT JOIN voter_data b 
    ON (md.matched_voter_id = b.nys_voter_id) 
    LEFT JOIN voter_history vh
    ON vh.nys_voter_id = b.nys_voter_id
    LEFT JOIN elections el on (vh.election_name = el.election_name";
if ($yv) { //Set up join parameters
    $tmpSql .= " AND el.election_year ";
    switch ($yv->operator) {
        case 'LIKE':
        case 'NOT LIKE':
            $tmpSql .= $yv->operator . " ('%" . $value . "%')";
        break;
        case 'NULL':
            $tmpSql .= " TRIM(IFNULL(el.election_year, '')) == ''";
        break;
        case 'NOT NULL':
            $tmpSql .= " TRIM(IFNULL(el.election_year, '')) > ''";
        break;
        case 'BETWEEN': 
            $tmpSql .= " BETWEEN ('".$yv->value[0]."') AND ('".$yv->value[1]."')";
        break;
        default: 
            $tmpSql .= $yv->operator . " ('" . $value . "')";
        break;
    }
}

$tmpSql .= ")";

if (count($queryArray)) {
    $tmpSql .= " WHERE ".implode($queryArray, ""); //Add where clause
    $tmpSql = rtrim($tmpSql, " ".$query[count($query) - 1]->lop); //Remove last logical operator
} 
$tmpSql .= " GROUP BY a.queueid, b.nys_voter_id"; //Add group by

$sqlpreview = "SELECT a.*, b.*, GROUP_CONCAT(DISTINCT vh.election_name ORDER BY vh.election_name DESC SEPARATOR ';') as voter_history ".$tmpSql;

$sqlcount = "SELECT count(*) as record_count FROM (SELECT a.* ".$tmpSql.") x";
$db = db_conn('@dcnxs_ny');

if ($action == "query") {
    $sqlpreview .= " LIMIT 4";
    $stmtcount = $db->Prepare($sqlcount);

    try {
        $rscount = $db->Execute($stmtcount);
    } catch (ADODB_Exception $e) {
        $db->disconnect();
        die(dbErr($e->getMessage()));  
    }
    pearErr($db, ADODB_PEAR_Error());
}
if ($action == "download") {
    $sqlpreview .= " LIMIT 100000";
}

$stmtpreview = $db->Prepare($sqlpreview);
try {
    $rspreview = $db->Execute($stmtpreview);
} catch (ADODB_Exception $e) {
    $db->disconnect();
    die(dbErr($e->getMessage()));  
}
pearErr($db, ADODB_PEAR_Error());

$db->disconnect();

$arrpreview = $rspreview->GetArray();

if ($action == "query") {
    $arrcount = $rscount->GetArray();
    $arr[0] = $arrcount[0]['record_count'];

    foreach ($arrpreview as $k => $p) {    
        if ($k == 0) {
            $prev[] = array_keys($p);
        }
        $prev[] = $p;
    }

    $arr[1] = $prev;

    echo json_encode($arr);
}
if ($action == "download") {
    ob_start();
    $tmpcsv = fopen('php://output', 'w');	
    foreach ($arrpreview as $k => $d) {
        if ($k == 0) {
            $file .= fputcsv($tmpcsv, array_keys($d));    
        }
        $file .= fputcsv($tmpcsv, array_values($d));
    }
    fclose($tmpcsv);
    $filedata = ob_get_contents();
    ob_end_clean();

    header('Content-Type: text/csv');
    header('Content-Disposition: attachment; filename="'.$filename.'"');
    header('Content-Transfer-Encoding: binary');
    header('Expires: 0');
    header('Cache-Control: must-revalidate, post-check=0, pre-check=0');
    header('Pragma: public');
    echo $filedata;
}