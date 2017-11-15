<# On SQL Prompt follow commands to multiplex control file

show parameter control_files
alter database backup controlfile to trace as 'C:\SP_CTL\control_bkp.trc' reuse ;
shutdown immediate ;
host copy E:\APP\CONTROL01.CTL C:\SP_CTL\CONTROL03.CTL
startup nomount;

alter system set control_files = "D:\APP\CONTROL01.CTL" ,
                                 "C:\SP_CTL\CONTROL03.CTL" scope=spfile;
                               
startup force;
show parameter control_files
#>

$username = "sys"
$password = "farooq"
$tns = "orcl"
$logon = “$username/$password as sysdba”
$bkpDir = "C:\ORA_REDO\"
$new_ctl = "C:\ORA_REDO\CONTROL01.CTL"
$logsql = "C:\ORA_REDO\logsqlcmd.txt"

function Invoke-SqlPlus ($sqlcmd) {  
    Write-Host "Starting Execution of $sqlcmd " -ForegroundColor Yellow
    $sqlcmd | sqlplus -S $logon 
}

function qryAddControlFile($ctlfiles){
    $finalQry = "alter system set control_files = "

    foreach($ctl in $ctlfiles){
        $finalQry += '"' + $ctl + '", '
    }

    $finalQry += '"' + $new_ctl + '" scope=spfile;' #always end sql statement with semi colon

    return $finalQry
}

function qryDelControlFile($ctlfiles){
    $finalQry = "alter system set control_files = "

    foreach($ctl in $ctlfiles){
        $ctlfile = [System.String] $ctl.Split('\')[-1]

        switch ($ctlfile){
          'CONTROL01.CTL' {$finalQry += '"' + $ctl + '", '}
        }    
    }

    $finalQry += '"' + $new_ctl + '" scope=spfile;' #always end sql statement with semi colon

    return $finalQry
}

function Backup_CtlSPFILE(){
    # Backup Control File and spfile as pfile
    $spfileBKP = $bkpDir + "pfile.ora_bkp"
    $ctlBKP = $bkpDir + "ctl_trace.txt"

    $bkpCTLnSPFILE = @"
           alter database backup controlfile to trace as '$ctlBKP' reuse ;
           create pfile='$spfileBKP' from spfile;
"@

    Invoke-SqlPlus $bkpCTLnSPFILE
}

function getControlFiles(){
    # Get Control file names from 
    $cfiles = Invoke-SqlPlus "SELECT name FROM V`$CONTROLFILE;"

    # Matching Strings starting with C-Z followed by a colon (represents a drive Letter)
    $ctlfiles = $cfiles | where { $_ -match "^([C-Z])+:.*" } 

    # Shutdown Database
    Invoke-SqlPlus "shutdown immediate;"

    # Copy control file to new location
    foreach($ctl in $ctlfiles){ $ctl_copy = $ctl}
    copy-item $ctl_copy $new_ctl 

    # Start DB in nomount state to alter control_files number
    Invoke-SqlPlus "startup nomount;"

    $sqlAlterCTLFile = qryAddControlFile($ctlfiles)

    Invoke-SqlPlus $sqlAlterCTLFile
}

# Backup Control File and SPFILE
Backup_CtlSPFILE | Out-File -Append $logsql 

<# Get Control File Name from v$controlfile 
   shutdown database
   Copy control file 
   startup nomount 
   alter system set control_files to previous and new control files
#>
$ctlfiles = getControlFiles | Out-File -Append $logsql

# Force Start Database
Invoke-SqlPlus "startup force;"

# Get Control file names from dynamic view
$ctlfile_added = Invoke-SqlPlus "SELECT name FROM V`$CONTROLFILE;" | Out-File -Append $logsql
