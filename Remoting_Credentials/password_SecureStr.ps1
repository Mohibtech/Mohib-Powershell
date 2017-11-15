# Read password from Host, save as secure string and plain text then return as plain text after Marshaling

$PlainPassword = Read-Host "Enter Password" -AsSecureString -AsPlainText -Force
$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($PlainPassword)
$PlainPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

Write-Host "Password is: " $PlainPassword
