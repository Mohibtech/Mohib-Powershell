# Credit to Rob Simmers 
# Based on link [https://powershell.org/forums/topic/ps-script-to-get-data-from-oracle-db-and-export-to-csv/]
function Get-OraResultDataTable{
    [CmdLetBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$conString,
        [Parameter(Mandatory=$true)]
        [string]$sqlString
    )
    begin {
        $resultSet=@()
    }
    process {
        try{
            Write-Verbose ("Connection String: {0}" -f $conString)
            Write-Verbose ("SQL Command: `r`n {0}" -f $sqlString)

            Add-Type -Path "C:\SOFTWARE\Databases\Oracle\Oracle Windows\ODAC\ODAC 12c\odp.net\managed\common\Oracle.ManagedDataAccess.dll"
            $con=New-Object Oracle.ManagedDataAccess.Client.OracleConnection($conString)
            $cmd=$con.CreateCommand()
            $cmd.CommandText=$sqlString

            $da=New-Object Oracle.ManagedDataAccess.Client.OracleDataAdapter($cmd);

            $resultSet=New-Object System.Data.DataTable

            [void]$da.fill($resultSet)
        }
        catch{
            Write-Error($_.Exception.ToString())
        }
        finally{
            if($con.State-eq'Open'){ 
                $con.close() 
             }
        }
    }
    end {
        $resultSet
    }

}

$userName = "system"
$password = "password"
$datasource = "srv/orcl"  # HOST/oracle service
$connectionString="User Id=$username;Password=$password;Data Source=$datasource"

$query=@"
SELECT country_id, Country_name, Region_id
FROM HR.COUNTRIES
"@

$results = Get-OraResultDataTable -conString $connectionString -sqlString $query -Verbose
$results | SELECT country_id, Country_name, Region_id | Export-CSV "C:\test.csv" -NoTypeInformation
