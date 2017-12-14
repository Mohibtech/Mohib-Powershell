
# Scheduling Jobs using paramHash
$paramHash = @{
Name = "DC Service Report"
FilePath = 'C:\scripts\Get-DCServiceReport.ps1'
Trigger = (New-Jobtrigger -Daily -At '8:00AM')
ScheduledJobOption = (New-ScheduledJobOption –RequireNetwork -RunElevated)
}

Register-ScheduledJob @paramHash 

# Run with elevated Privileges
$trigger = New-JobTrigger -Once -At "12:51"
$option = New-ScheduledJobOption -RunElevated –ContinueIfGoingOnBattery

Register-ScheduledJob -Name OraServiceStatus -ScriptBlock {Get-Service -name "OracleService*"} -Trigger $trigger -ScheduledJobOption $option 


