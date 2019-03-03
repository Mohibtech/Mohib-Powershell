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
   SetEnvVariables -pathvar ';C:\ProgramData\chocolatey\bin'
   Need to add ';' in path string before adding path entry other it would concatenate with the last path entry and make it useless.
.EXAMPLE
   SetEnvVariables -EnvVarName 'SPARK_HOME' -EnvVarValue 'C:\spark\spark-2.4.0-bin-hadoop2.7'
   This will add environment variable SPARK_HOME to system pointing to folder "C:\spark\spark-2.4.0-bin-hadoop2.7" 
.INPUTS
   -pathvar (new path entry, string starts with ';' for concatenation with other entries) 
   -pathdel (provide 'Y' if want to delete a path entry in path variable, used with -pathvar argument)
   -EnvVarName (name of new Environment Variable, use with -EnvVarValue)
   -EnvVarValue (value of new Environment Variable, use with -EnvVarName)
.NOTES
   -pathvar and -pathdel are not used with last two arguments -EnvVarName and -EnvVarValue.
   -EnvVarName and -EnvVarValue are used together as name and value pair.
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
