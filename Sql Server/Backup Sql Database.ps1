#Set-ExecutionPolicy RemoteSigned
#import-module sqlps

$dt = Get-Date -Format yyyyMMdd
$dbname = "Metadata"
$srvr = "gt02"
$backupDest = "E:\BACKUPS\Metadata_Backup\" + $dbname + ".bak"

Backup-SqlDatabase -ServerInstance $srvr -Database $dbname -BackupFile $backupDest -Initialize

Invoke-Expression E:\BACKUPS\Metadata_Backup\PS_ARCHIVE.ps1


