#First save password in a file while reading from host
read-host -AsSecureString | ConvertFrom-SecureString | out-file D:\cred.txt

#Then using the below script to send email using gmail credentials.
$filepath = 'D:\cred.txt'
$secpass = get-content $filepath | ConvertTo-SecureString
$user = 'test@gmail.com'

$cred = new-object -typename System.Management.Automation.PSCredential $user,$secpass

$param = @{
    SmtpServer = 'smtp.gmail.com'
    Port = 587
    UseSsl = $true
    Credential  = $cred
    From = 'test@gmail.com'
    To = 'test@analytics.com'
    Subject = 'Sending emails again'
    Body = "Check out the PowerShellMagazine.com website!"
    #Attachments = 'D:\articles.csv'
}

Send-MailMessage @param
