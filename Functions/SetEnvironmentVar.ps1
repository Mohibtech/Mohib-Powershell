<#
.Synopsis
   Modify Environment Variables
.DESCRIPTION
   Set or Delete paths in environmental variable $PATH. 
   Also sets general environment variables.
.EXAMPLE
   SetEnvVariables -pathvar 'C:\WINDOWS\System32\OpenSSH\' -pathDel 'Yes'
   Deletes path entry 'C:\WINDOWS\System32\OpenSSH\' from $PATH
.EXAMPLE
   SetEnvVariables -pathvar 'C:\ProgramData\chocolatey\bin'
.EXAMPLE
   SetEnvVariables -EnvVarName 'Choco' -EnvVarValue 'C:\ProgramData\chocolatey\bin'

.INPUTS
   Inputs to this cmdlet (if any)
#>
function SetEnvVariables {
    param(
       [string]$pathvar,
       [string]$EnvVarName,
       [string]$EnvVarValue,
       [string]$pathDel
       )

    $path = [Environment]::GetEnvironmentVariable('PATH' ,'User' )
 
    If ($PSBoundParameters.ContainsKey('pathvar')) {
        # check If need to delete something from path variable by checking 'pathDel' 
        If ($PSBoundParameters.ContainsKey('pathDel')) {
           $path = ($path.split(';') | Where { $_ -ne $pathvar }) -join ';'
           [Environment]::SetEnvironmentVariable('PATH', $path, 'User') 
        }
        else {
           [System.Environment]::SetEnvironmentVariable('PATH', $env:path + $pathvar, 'User')     
        }
    }

    If ($PSBoundParameters.ContainsKey('EnvVarName')) {
        [Environment]::SetEnvironmentVariable($EnvVarName , $EnvVarValue , "User" )
    }
}
