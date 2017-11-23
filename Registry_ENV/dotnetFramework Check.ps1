# Checking Different Versions of .Net Framework 
gci 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP'-recurse |
gp -name Version, Release -EA 0 |where { $_.PSChildName -match '^(?!S)\p{L}' } |
select Version , Release , PSChildName 

# Checking Different Version with If statements
$ndpDirectory="hklm:\SOFTWARE\Microsoft\NET Framework Setup\NDP\"
$v4Directory = "$ndpDirectory\v4\Full"

if (Test-Path "$ndpDirectory\v2.*") 
    {  Get-ItemProperty "$ndpDirectory\v2.*" -name Version | select Version }
if (Test-Path "$ndpDirectory\v3.*") 
    {  Get-ItemProperty "$ndpDirectory\v3.*" -name Version | select Version }
if (Test-Path $v4Directory) 
    {  Get-ItemProperty $v4Directory  }
