# parse through a log file searching for lines that contain strings. 
$path = pushd \\Eldorado\el\Processing\IVR_New\Log

$files = Dir -filter *.txt | Where-Object { $_.CreationTime -gt (Get-Date).AddDays(-2) } 

ForEach ($file in $files)
{
  Get-Content $file |
  Select-String -pattern "Found file"|
  Format-Table -property Line
} 

