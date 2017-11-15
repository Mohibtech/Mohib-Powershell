$username = "sys"
$password = "farooq"
$tns = "orcl"
$logon = “$username/$password as sysdba”
$new_ctl = "C:\ORA_REDO\CONTROL05.CTL"

# Construct Query using control file names in array $ctlfiles
function qryConstruct($ctlfiles){
    $finalQry = "alter system set control_files = "

    foreach($ctl in $ctlfiles){
        $finalQry += '"' + $ctl + '", '
    }

    $finalQry += '"' + $new_ctl + '" scope=spfile'

    return $finalQry
}

function Invoke-SqlPlus ($sqlcmd) {  
    Write-Host "Starting Execution of `n $sqlcmd "
    $sqlcmd | sqlplus -S $logon; 
}

$cfiles = Invoke-SqlPlus "SELECT name FROM V`$CONTROLFILE;"
#$qryResult

#$cfiles
Write-Host " Counting the length of control files `n" $cfiles.count

# Matching Strings starting with C-Z followed by a colon (represents a drive Letter)
$ctlfiles = $cfiles | where { $_ -match "^([C-Z])+:.*" } 

Write-Host "Length of control files after pattern matching `n" $ctlfiles.Length
$ctlfiles[0]


$sqlAddCTLFile = qryConstruct($ctlfiles)

$sqlAddCTLFile
