<?php
ini_set('max_execution_time', 0); //300 seconds = 5 minutes
/**
 * @author Gene C. Garber <gene.garber@gmail.com>
 * @copyright Copyright (c) 2014, Gene C. Garber - all rights reserved
 * @version 1.0
 * @package Corm (tm) - extension
 */
require_once('../../header.inc.php');

if (!isset($_GET['custcodes'])){
    $_GET['custcodes'] = '';
	
}
if (!isset($_GET['start_date'])){
    $_GET['start_date'] = '';
	
}
if (!isset($_GET['end_date'])){
    $_GET['end_date'] = '';
	
}
if (!isset($_GET['active'])){
    $_GET['active'] = '';
	
}
if (!isset($_GET['is_managed'])){
    $_GET['is_managed'] = '';
	
}


ob_end_clean();
header('Pragma: public');
header("Cache-Control: must-revalidate, post-check=0, pre-check=0");
header("Cache-Control: public");
header("Expires: 0"); // Date in the past
header("Content-Disposition: attachment; filename=download_" . date('Y_m_d_H_i_s') . ".csv");
header('Content-Transfer-Encoding: binary');
header("Content-type: application/vnd.ms-excel");

$DB = DB::getCon();
$filename = 'c:/php_temp/download_' . preg_replace('/[^a-z0-9]/i', '_', $DB->cleanString($_GET['custcodes'])) . '.csv';

$_GET['custcodes'] = $DB->cleanString($_GET['custcodes']);
$_GET['start_date'] = $DB->cleanString($_GET['start_date']);
$_GET['end_date'] = $DB->cleanString($_GET['end_date']);
$_GET['active'] = $DB->cleanString($_GET['active']);
$_GET['is_managed'] = $DB->cleanString($_GET['is_managed']);

$start_date = $_GET['start_date'];
$end_date = $_GET['end_date'];
$active = $_GET['active'];
$managed = $_GET['is_managed'];

$_GET['custcodes'] = implode("','", explode(',',$_GET['custcodes']));


$month = date('m');
$year = date('Y');

if($start_date == ""){
$start_date = " '2010-01-01' ";
}
else {
$start_date = "'".$start_date."'";
}

if($end_date == ""){
$end_date = " ' ".date("Y-m-d")." ' ";
} else {
$end_date = "'".$end_date."'";
}

$CSVExport = new CSVExport($filename);
// For memory concerns you could also select a short stack of rows using limit
//  just in case you didn't think of that already.
/**
 * Who wrote this above comment? - Gene C. Garber 03-29-2013
 * There are no memory concerns with the CSVExport class.
 * If you were speaking of the query below that is true except for it has not been a concern.
 * Please note comments with your name and the date.
 */

//error_log(print_r($_GET,true));

$sql = "
Select
  tslo.created,
  tslo.created_by,
  tslo.last_modified,
  tslo.last_modified_by,
  tslo.customer_code,
  tslo.name,
  tsl.loan_identifier,
  tst.command,
  tsl.tax_search_loan_id as id
From
  tax_search_loan_officers tslo Left Join
  tax_search_loans tsl On tsl.tax_search_loan_officer_id =
    tslo.tax_search_loan_officer_id Left Join
  tax_search_track tst On tst.pick_userid = tslo.pick_userid
Where
  tslo.customer_code IN ('".$_GET['custcodes']."')
  AND
   tslo.active Not In ('N') And
  tslo.is_manager Not In ('N') And  
  Not tst.command Is Null
  ";
  
 if($active != ""){
 $sql .= " AND tslo.active = '".$active."'";
}

if($managed != ""){
$sql .= "AND tslo.is_manager= '".$managed."'";
}



$sql .= " AND ";

$sql .= trim($start_date)." <= tslo.last_modified";

$sql.= " AND ";

$sql .= "tslo.last_modified <= ".trim($end_date);


	
//echo $sql;
//exit;

$rows = $DB->getRows($sql);
if (count($rows)) {
    // header row
    $CSVExport->writeHeader($rows[0]);
    $row_cnt = count($rows);

    // write data from the rest of the rows
    for ($i=0; $i < $row_cnt; $i++) {
        $current_row = $rows[$i];
            
        $CSVExport->writeRow($current_row);
		}
}


unset($CSVExport); // closes the file handle

$output = file_get_contents($filename);

header('Content-length: ' . strlen($output));

echo $output;
