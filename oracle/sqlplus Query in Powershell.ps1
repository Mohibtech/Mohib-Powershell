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


