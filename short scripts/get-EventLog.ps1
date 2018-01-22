
#Get the five most recent entries from a specific event log on the local computer
Get-EventLog -Newest 5 -LogName "Application"

Get-EventLog system -newest 3

Get-EventLog -list | Where {$_.logdisplayname -eq "System"}

# retrieves only those events in the Windows PowerShell event log that have an EventID equal to 403
Get-EventLog "Windows PowerShell" | Where {$_.EventID -eq 403}

# Equivalent of more command in linux
get-eventlog -LogName "Windows PowerShell" | Out-Host -Paging

# Find all sources that are represented in a specific number of entries in an event log
$Events = Get-Eventlog -LogName system -Newest 1000
$Events | Group-Object -Property source -noelement | Sort-Object -Property count -Descending

