Set-ExecutionPolicy RemoteSigned

import-module sqlps

$dt = Get-Date -Format yyyyMMdd
$ext = '.bak'
$dbname = 'Sales_DW'
$srvr = 'GT030\SQLEXPRESS'
$baseDir='D:\Backup\SQLServer\SalesDW\'
$backupDest = $baseDir +  dbname + $ext

Backup-SqlDatabase -ServerInstance $srvr  -Database $dbname -BackupFile $backupDest
