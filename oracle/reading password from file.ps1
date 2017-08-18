# Read password from host and save it in a file then comment Read-Host line (Line 3)
$pfile = "D:\Backup\PS\pora.txt"
Read-Host "Enter Password" -AsSecureString |  ConvertFrom-SecureString | Out-File $pfile

function Decrypt-SecureString {
param(
    [Parameter (ValueFromPipeline=$true, Mandatory=$true ,Position = 0)]
    [System.Security.SecureString]
    $sstr
)

$marshal = [System.Runtime.InteropServices.Marshal ]
$ptr = $marshal::SecureStringToBSTR( $sstr )
$str = $marshal::PtrToStringBSTR( $ptr )
$marshal::ZeroFreeBSTR( $ptr )
$str
}

$penc = Get-Content $pfile | ConvertTo-SecureString

$oraps = Decrypt-SecureString( $penc)
$logon = "sys"+ "/" + $oraps + " as sysdba"

$sqlQuery = @"
       alter database backup controlfile to trace as 'D:\Backup\PS\ctl_trace.log' reuse ;
       create pfile from spfile;
"@

$sqlQuery | sqlplus.exe $logon
