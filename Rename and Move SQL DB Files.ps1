#Renaming and Moving SQL DB Files

$dbname = "Sales_DW"
$ext = ".bak"
$base_dir="D:\Backup\SQLServer\SalesDW\"
$archiveFolder = $base_dir + "Archive\"
$sourceFileName =   $dbname + $ext
$newFileName = $base_dir + $dbname + "_" + (Get-Date -Format "yyyy-MM-ddhhmmss" ) + $ext

$Now = Get-Date
$Days = "1"
$LastWrite = $Now.AddDays(-$Days)

echo $sourceFileName
echo $newFileName

Function RenameMoveFile ( $fileName )
{
    $date = Get-Date -uFormat "%Y%m%d"
 
    write- host "Renaming File $sourceFileName " -ForegroundColor "Blue"
    Rename-Item $fileName $newFileName
  
    write- host "Moving File to $archiveFolder " -ForegroundColor "Magenta"
    Move-Item $newFileName $archiveFolder
}


#######get files based on lastwrite filter and specified folder ######
Function DeleteFiles
{

    $FilesToDelete = Get-Childitem $base_dir -Include "*.bak" -Recurse |
               Where {$_ .LastWriteTime - le "$LastWrite" }
   
    foreach ($FileToDel in $FilesToDelete)
    {
        if ($FileToDel -ne $NULL)  {
            write-host "Deleting File $FileToDel" -ForegroundColor "DarkRed"
            Remove-Item $FileToDel .FullName | out-null          }
        else
              { Write-Host "No more files to delete!" -ForegroundColor "Green"   }
    }
}

RenameMoveFile -fileName $sourceFileName
DeleteFiles
