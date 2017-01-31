#Renaming and Moving SQL DB Files

$dbname="Sales_DW"
$ext = ".bak"
$srcFileName = $dbname + $ext
$base_dir="D:\Backup\SQLServer\SalesDW\"
$logfile = $base_dir + $dbname + "log.txt"
$archiveFolder = $base_dir + "Archive\"
dtformat = (Get-Date -Format "ddMMyy_hhmm" )
$newFileName = $dbname + "_" + dtformat + $ext

Set-Location $base_dir

Function RenameCopyFile
{
    [CmdletBinding()] 
    Param ( [Parameter(Mandatory=$true)]
            [String]$fileName ) 
 
    #Test the local file exists or not 
    If (-Not (Test-Path $fileName)) 
    { 
        Write-Output "$fileName does not exists!" | Out-File $logfile -Append;   
    } 
    else
    { 
        $date = Get-Date -uFormat "%Y%m%d"
    
        Write-Output "Copying File to $archiveFolder" | Out-File $logfile -Append;
        Copy-Item $fileName $archiveFolder

        #Setting location to Archive Folder
        Set-Location $archiveFolder

        Write-Output "Renaming File $srcFileName to $newFileName" | Out-File $logfile -Append;  
        Rename-Item $fileName $newFileName 
    }
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

#Rename Current Database Backup file
RenameCopyFile -fileName $srcFileName

#Setting days to removing files older than LastWrite variable
$Days = "3"
$LastWrite = $Now.AddDays(-$Days)

#Delete Files older than above specified $Days
DeleteFiles
