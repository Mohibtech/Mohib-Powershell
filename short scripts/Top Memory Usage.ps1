#Top 5 processes with respect to Memory Usage

Get-Process | Sort ws -Descending|select -first 5| 
Select processname, @{Name="Mem Usage(MB)";Expression={[math]::round($_.ws / 1mb)}} 
