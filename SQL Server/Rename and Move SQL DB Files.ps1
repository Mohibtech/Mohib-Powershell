#Renaming and Moving SQL DB Files

$dbname="Sales_DW"
$ext = ".bak"
$base_dir="E:\BACKUPS\Metadata_Backup\"
$logfile = $base_dir + $dbname + ".log"
$archiveFolder = $base_dir + "Archive\"
$srcFileName =   $dbname + $ext
$newFileName = $dbname + "_" + (Get-Date -Format "ddMMMyyyy_hhmm" ) + $ext

Set-Location $base_dir

Function CopyRenameFile
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
        Write-Output "Copying File to $archiveFolder" | Out-File $logfile -Append;
        Copy-Item $fileName $archiveFolder

        #Setting location to Archive Folder
        Set-Location $archiveFolder

        Write-Output "Renaming File $srcFileName to $newFileName" | Out-File $logfile -Append;  
        Rename-Item $fileName $newFileName 
    }
}

####### Get files based on lastwrite filter and specified folder ######
Function DeleteFiles($Days)
{
    $Now = Get-Date
    $LastWrite = $Now.AddDays(-$Days)
    
    $FilesToDelete = Get-Childitem $base_dir -Include "*.bak" -Recurse |
               Where {$_ .LastWriteTime - le "$LastWrite" }
   
    foreach ($FileToDel in $FilesToDelete)
    {
        if ($FileToDel -ne $NULL)  {
            write-host "Deleting File $FileToDel" | Out-File $logfile -Append;
            Remove-Item $FileToDel.FullName | | Out-File $logfile -Append;
        }
        else
           { Write-Host "No more files to delete!" | Out-File $logfile -Append;   }
    }
}

#Rename Current Database Backup file
CopyRenameFile -fileName $srcFileName

#Delete Files older than above specified $Days
DeleteFiles -Days 3 
