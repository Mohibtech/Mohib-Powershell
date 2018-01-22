
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
$Events | Group -Property source -noelement | Sort -Property count -Descending

Get error events from a specific event log
Get-EventLog -LogName System -EntryType Error | group Source

# Get events from a specific event log with an Instance ID and Source value
Get-EventLog -LogName System -InstanceID 3221235481 -Source "DCOM"

# Get all events in an event log that have include a specific word in the message value
Get-EventLog -LogName "Windows PowerShell" -Message "*failed*"


# Get events from an event log with using a source and event ID
Get-EventLog -Log "Application" -Source "Outlook" | where {$_.eventID -eq 34}

# Get events in an event log, grouped by a property
Get-EventLog -Log System -UserName "NT*" | 
Group -Property "UserName" -noelement | Format-Table Count, Name -Auto

# Get all errors in an event log that occurred during a specific time frame
$JAN20 = Get-Date 20/1/18
$JAN22 = Get-Date 22/1/18
Get-EventLog -Log "System" -EntryType Error -After $JAN20 -before $JAN22 | Out-File C:\Users\Testing.txt

# Get only the error entries from local System log on a certain day
Get-EventLog -Log "System"  -After "09/28/2015" -Before "09/29/2015" -EntryType Error

# Get Error and Warning Entries from local System log on a certain day
Get-EventLog -Log "System"  -After "09/28/2015" -Before "09/29/2015" | 
Where {$_.EntryType -like 'Error' -or $_.EntryType -like 'Warning'}

