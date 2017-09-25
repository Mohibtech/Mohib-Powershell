function OutputHashes(){
     Write-Output "######################################################################## `n" | Out-File -Append $outputfile
}

function copyCSVFiles {
    [CmdletBinding()]
    param()

    $srcPath = 'D:\Backup\Oracle\'
    $destPath = 'D:\Backup\PS\Oracle_PS\KMX\'

    $src_script = $srcPath + 'script_01.sql'
    $src_Metadata = $srcPath +"FULLDB_METADATA.DMP"
    
    $dest_script = $destPath + '01_script.sql'
    $dest_Metadata = $destPath +"DB_METADATA.DMP"
	
    Write-Verbose "Starting copying file at $LogDate"	
    OutputHashes

    Write-Output "Start Time => $LogDate" | Out-File -Append $outputfile 
    Write-Output "Copying script_01.sql file to $destPath as 01_script.sql " | Out-File -Append $outputfile 
    Copy-Item $src_script $dest_script
    
    Write-Output "Copying FULLDB_METADATA.DMP file to $destPath as DB_METADATA.DMP " | Out-File -Append $outputfile 
    Copy-Item $src_Metadata $dest_Metadata
    
    Write-Output "End Time => $LogDate" | Out-File -Append $outputfile 
    OutputHashes
}

$LogDate = Get-Date -Format "HH:mm:ss dd-MMM-yyyy" 
$outputfile = "PS_File_Copy.log" 

############## Copying CSV files to Working Folder ############################
copyCSVFiles -Verbose 
