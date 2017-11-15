$username = "sys"
$password = "farooq"
$tns = "orcl"
$logon = “$username/$password as sysdba”
$new_ctl = "C:\ORA_REDO\CONTROL04.CTL"


function qryConstruct($ctlfiles){
    $finalQry = "alter system set control_files = "

    foreach($ctl in $ctlfiles){
        $finalQry += '"' + $ctl + '", '
    }

    $finalQry += '"' + $new_ctl + '" scope=spfile'

    return $finalQry
}

function Invoke-SqlPlus ($sqlcmd) {  
    Write-Host "Starting Execution of $sqlcmd "
    $sqlcmd | sqlplus -S $logon; 
}



$cfiles = Invoke-SqlPlus "SELECT name FROM V`$CONTROLFILE;"
#$qryResult

$cfiles
Write-Host " Counting the length of control files " $cfiles.count

# Matching only Control Files starting with D: (on drive D:\)
$ctlfiles = $cfiles | where { $_ -match "D:*" } 

$ctlfile_num = $ctlfiles.Length
$ctlfiles[0]

$sqlAddCTLFile = qryConstruct($ctlfiles)

$sqlAddCTLFile
