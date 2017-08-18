$username = "HR"
$password = "passwd"
$tns = "orcl"
$ctl_DC="DC_EXT.ctl"
$ctl_ZN="ZN_EXT.ctl"
$logon = “$username/$password@$tns”
$outputfile = "Table_loading.log" 

function Invoke-SqlPlus($sqlcmd, $text) {
    Write-Output "Starting Execution of command "  $text | Out-File -Append $outputfile    
    $sqlcmd | sqlplus -S $logon | Out-File -Append $outputfile ;
    Write-Output "############################################## `n" | Out-File -Append $outputfile 

    if (!$? -or # Stop on non-zero exit codes.
        # Stop on script errors. Have to detect them from output
        # unfortunately, as I couldn't find a way to make SQL*Plus halt on
        # warnings.
		$output -match "compilation errors" -or 
		$output -match "unknown command" -or 
		$output -match "Input is too long" -or
		$output -match "unable to open file") 
    { 
		throw "Command failed: $sqlcmd"; 
	}

}

function Invoke-Sqlldr($ctl, $logfile) {
    Write-Output "Loading table using $ctl control file" | Out-File -Append $outputfile 
    sqlldr userid=$username/$password control=$ctl log=$logfile | Out-File -Append $outputfile 
    Write-Output "################################################################### `n" | Out-File -Append $outputfile 
}

$sqlDC = @"
		truncate table DC_EXT_TEMP;
        exit
"@

$sqlZN = @"      
		truncate table ZN_EXT_TEMP;
        exit
"@

############## Truncating TEMP Tables ############################
Invoke-SqlPlus $sqlDC "truncate table DC_EXT_TEMP;"
Invoke-SqlPlus $sqlZN "truncate table ZN_EXT_TEMP;"

############ Loading of TEMP tables using sqlldr utility
Write-Output "############# Loading of TEMP tables starting ############################ `n" | Out-File -Append $outputfile 

Invoke-Sqlldr $ctl_DC "DC_EXT.log"
Invoke-Sqlldr $ctl_ZN "ZN_EXT.log"

Write-Output "############## Loading of TEMP tables ending ###########################" | Out-File -Append $outputfile 

############## Drop Sequences ###################################
$sqlDropSequences = @"
		DROP SEQUENCE HR.GNSQ_DC_EXT;
        DROP SEQUENCE HR.GNSQ_ZN_EXT;
        exit
"@

Invoke-SqlPlus $sqlDropSequences "Dropping sequences GNSQ_DC_EXT and GNSQ_ZN_EXT "


$sqlCreateSequences = @"
    CREATE SEQUENCE HR.GNSQ_DC_EXT 
    MINVALUE 0 
    MAXVALUE 9999999999999999999999999999 
    INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER NOCYCLE;

    CREATE SEQUENCE HR.GNSQ_ZN_EXT 
    MINVALUE 0 MAXVALUE 9999999999999999999999999999 
    INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER NOCYCLE;

    exit
"@

Invoke-SqlPlus $sqlCreateSequences "Creating sequences GNSQ_DC_EXT and GNSQ_ZN_EXT "

$sqlTruncMainTables = @"
		truncate table DC_EXT;
        truncate table ZN_EXT;
        exit
"@

############## Truncating Main Tables ##################################################################
Invoke-SqlPlus $sqlTruncMainTables "Truncating Main tables TKMX01V1_QC1_DC_EXT and TKMX01V1_QC1_ZN_EXT"

############## Inserting into Main Tables from TEMP tables ################################################
$sqlInsertDC_EXT = @"
insert into  DC_EXT
select GNSQ_DC_EXT.NEXTVAL, DC_EXT_DEPT, DC_EXT_STYLE, QC1_DC_EXT_CATG 
FROM (select distinct QC1_DC_EXT_DEPT , QC1_DC_EXT_STYLE, QC1_DC_EXT_CATG 
     from DC_EXT_TEMP) ;

exit
"@

############## Inserting into table TKMX01V1_QC1_DC_EXT ###################################################################
Invoke-SqlPlus $sqlInsertDC_EXT "Inserting in Main table DC_EXT"

$sqlInsertZN_EXT = @"
insert into ZN_EXT
select GNSQ_ZN_EXT.NEXTVAL, QC1_ZN_EXT_STYLE, QC1_ZN_EXT_DEPT, 
FROM (select distinct QC1_ZN_EXT_STYLE, QC1_ZN_EXT_DEPT
     from ZN_EXT_TEMP);
"@

############## Inserting into table TKMX01V1_QC1_ZN_EXT ###################################################################
Invoke-SqlPlus $sqlInsertZN_EXT "Inserting in Main table ZN_EXT"
