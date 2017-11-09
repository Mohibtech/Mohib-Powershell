# Finding .Net Framework versions
$ndp = 'hklm:\SOFTWARE\Microsoft\NET Framework Setup\NDP\'

Get-ChildItem $ndp -rec -ea SilentlyContinue | 
foreach {  
    $currentKey = Get-ItemProperty -Path $_.PsPath 
    $currentKey | select Version, PSChildName | where { $_.PSChildName -match 'v.*|Client' }

}
