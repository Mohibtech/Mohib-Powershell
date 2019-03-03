function testEnvVariables() {
    param(
       [string]$pathvar,
       [string]$varEnv
       )

    # Display all the passed parameters:
    $PSBoundParameters
    
    Write-Host $pathvar
    write-Host "Now second param varEnv" $varEnv
    If ($PSBoundParameters.ContainsKey('pathvar')) {
      Write-Output -InputObject "Path has been included as: '$pathvar'"
    }
    If ($PSBoundParameters.ContainsKey('varEnv')) {
        Write-Output -InputObject "New Env Variable is : '$varEnv'"
    }
}

$pvar = 'C:\Users\Humera\AppData\Roaming\npmC:\spark\spark-2.4.0-bin-hadoop2.7\bin'
$var = 'Hadoop_Home'

testEnvVariables -pathvar $pvar -varEnv $var
