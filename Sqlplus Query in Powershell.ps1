$sqlQuery = @"
		set heading on
		set feedback on
		select count(1) from mohib.DC_EXT_TEMP;
		exit
"@

$username = "mohib"
$password = "mohib"
$tnsalias = "orcl"
$outputfile = "sql_log.txt" 

$sqlQuery | sqlplus -silent $username/$password@$tnsalias | Out-File $outputfile 


Sqlldr in Powershell

$username = "U_83201254955235"
$password = "U_83201254955235"
$tnsalias = "orcl"
$control="TKMX01V1_QC1_DC_EXT.ctl"
$log="DC_EXT.log"
$outputfile = "sql_log.txt" 
