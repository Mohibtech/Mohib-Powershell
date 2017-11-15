$username = "sys"
$password = "farooq"
$tns = "orcl"
$logon = “$username/$password as sysdba”
$bkpDir = "C:\ORA_REDO\"
$new_ctl = "C:\ORA_REDO\CONTROL04.CTL"

function qryConstruct($ctlfiles){
    $finalQry = "alter system set control_files = "

    foreach($ctl in $ctlfiles){
        $finalQry += '"' + $ctl + '", '
    }

    $finalQry += '"' + $new_ctl + '" scope=spfile;'

    return $finalQry
}

function Invoke-SqlPlus ($sqlcmd) {  
    Write-Host "Starting Execution of `n $sqlcmd" -ForegroundColor Yellow
    $sqlcmd | sqlplus -S $logon; 
}

# Backup Control File and spfile as pfile
function Backup_CtlSPFILE(){
    # Backup Control File and spfile as pfile
    $spfileBKP = $bkpDir + "pfile.ora_bkp"
    $ctlBKP = $bkpDir + "ctl_trace.log"

    $bkpCTLnSPFILE = @"
           alter database backup controlfile to trace as '$ctlBKP' reuse ;
           create pfile='$spfileBKP' from spfile;
"@

    Invoke-SqlPlus $bkpCTLnSPFILE
}

Backup_CtlSPFILE

# Get Control file names from 
$cfiles = Invoke-SqlPlus "SELECT name FROM V`$CONTROLFILE;"

# Select only values starting with Drive Letter (to exclude anything other than control file names
$ctlfiles = $cfiles | where { $_ -match "D:*" } 

# Shutdown Database
Invoke-SqlPlus "shutdown immediate;"

#Copy Control file to new location while Database is shutdown
copy-item $ctlfiles[0] $new_ctl 

# Start DB in nomount state to alter control_files number
Invoke-SqlPlus "startup nomount;"

# Construct alter system set control_files query using qryConstruct
$sqlAddCTLFile = qryConstruct($ctlfiles)

Invoke-SqlPlus $sqlAddCTLFile

# Force Start Database
Invoke-SqlPlus "startup force;"

# Get Control file names from 
$ctlfile_added = Invoke-SqlPlus "SELECT name FROM V`$CONTROLFILE;"
$ctlfile_added
