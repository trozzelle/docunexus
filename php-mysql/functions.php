<?php
function parseFilePreview($filename, $file, $sequence, $data) {
	$mapping = false;
	$header = false;
	$status = false;
	
	if ($data) {
		$mapping = $data['mapping'];
		$header = $data['header'];
		$status = $data['status'];
	}
	
	//Array of alpha columns to map to numbers
	$alphabet = array('A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z','AA','AB','AC','AD','AE','AF','AG','AH','AI','AJ','AK','AL','AM','AN','AO','AP','AQ','AR','AS','AT','AU','AV','AW','AX','AY','AZ');
	
	if (!$file) {
		die('{"error": "No file provided"}');
	}
	//Explode the file in to lines
	$lines = explode(PHP_EOL, $file);
	
	if (empty($lines)) {		
		die('{"error": "Error exploding CSV for mapping preview"}');
	}

	//Get the first 5 lines, if that many exist
	for ($i = 0; $i <= 4; $i++) {
		if (($i + 1) > count($lines)) {
			break; //If there's less than 5 lines, break the loop
		}
		$data = str_getcsv($lines[$i]);    //Get the CSV content of the current line
		if ($data !== FALSE && json_encode($data) !== FALSE) {
			$csv[] = $data;  //If there's data and it doesn't blow up when we try to encode it, add it to the array
		}    
	}

	if (empty($csv)) {
		die('{"error": "Error parsing CSV data for mapping preview"}');
	}

	$arr_data = array();
	foreach ($csv as $rowid => $row) {
		foreach ($row as $k => $v) {        
			$arr_data[$rowid][$alphabet[$k]] = oraEscape($v); //Create an array that maps each value to an alpha key, for mapping purposes
		}
	}

	if (empty($arr_data)) {
		die('{"error": "Error mapping CSV data to columns for mapping preview"}');
	}
	
	
	$out = json_encode(array('file' => $filename, 'preview' => $arr_data, 'mapping' => $mapping, 'header' => $header, 'sequence' => $sequence));
	echo $out;
}

function formatUserData($arr) {
	$arr_out = array();
	foreach ($arr as $a) {
		$uid = $a['userid'];
		if (!$arr_out[$uid]) {
			$arr_out[$uid] = array(
				'userid' => $a['userid'],
				'username' => $a['username'],
				'email' => $a['email'],
                'auth_token' => $a['auth_token'],
                'auth_token_expires' => $a['auth_token_expires'],
				'display_name' => $a['display_name'],
				'site_admin' => $a['site_admin'],
				'admin' => array('site_admin' => 'N', 'region_admin' => 'N', 'group_admin' => 'N'),
				'enabled' => $a['enabled'],
				'groups' => array(),
				'regions' => array()
			);		
		}
		if ($a['site_admin'] == 'Y') {
			$arr_out[$uid]['admin']['site_admin'] = 'Y';
		}
		if ($a['groupid']) {			
			$arr_out[$uid]['groups'][$a['groupid']] = array('groupid' => $a['groupid'], 'group_name' => $a['group_name'], 'group_admin' => $a['group_admin']);     
			if ($a['group_admin'] == 'Y') {
				$arr_out[$uid]['admin']['group_admin'] = 'Y';
			}   
		}
		if ($a['regionid']) {						
			$arr_out[$uid]['regions'][$a['regionid']] = array('regionid' => $a['regionid'], 'region_name' => $a['region_name'], 'region_admin' => $a['region_admin']);        
			if ($a['region_admin'] == 'Y') {
				$arr_out[$uid]['admin']['region_admin'] = 'Y';
			}   
		}		
	}
	foreach ($arr_out as $k => &$user) {
		$user['groups'] = array_values($user['groups']);
		$user['regions'] = array_values($user['regions']);
	}
	return json_encode(array_values($arr_out)[0]);
}

function getFileDelimiter($file, $checkLines = 2){
    $file = new SplFileObject($file);
    $delimiters = array(
      ',',
      '\t',
      ';',
      '|',
      ':'
    );
    $results = array();
    $i = 0;
     while($file->valid() && $i <= $checkLines){
        $line = $file->fgets();
        foreach ($delimiters as $delimiter){
            $regExp = '/['.$delimiter.']/';
            $fields = preg_split($regExp, $line);
            if(count($fields) > 1){
                if(!empty($results[$delimiter])){
                    $results[$delimiter]++;
                } else {
                    $results[$delimiter] = 1;
                }   
            }
        }
       $i++;
    }
    $results = array_keys($results, max($results));
    return $results[0];
}