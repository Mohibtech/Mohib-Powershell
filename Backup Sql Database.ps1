Set-ExecutionPolicy RemoteSigned

import-module sqlps

$dt = Get-Date -Format yyyyMMdd
$ext = '.bak'
$dbname = 'Sales_DW'
$srvr = 'GT030\SQLEXPRESS'
$baseDir='D:\Backup\SQLServer\SalesDW\'
$backupDest = $baseDir +  $dbname + $ext

$backupQuery = "BACKUP DATABASE $dbname TO DISK=N'$backupDest' WITH INIT"

Backup-SqlDatabase -ServerInstance $srvr  -Database $dbname -BackupFile $backupDest

#Invoke-Sqlcmd  -Query $backupQuery ;
