# Creating Dynamic SQL to 
# Query Table Partitions and
# Count Rows in each partition
# Using Get-OraResultDataTable function twice

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

            Add-Type -Path "H:\SOFTWARE\Databases\Oracle\Oracle Windows\ODAC\ODAC 12c\odp.net\managed\common\Oracle.ManagedDataAccess.dll"
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


$srvrname = "192.168.10.227"
$service = "orcl"
$datasource = $srvrname + '/' + $service
$username = "system"
$passwd = "Aa123456"
    
$connStr="User Id=$username;Password=$passwd;Data Source=$datasource"


$owner = "CCYV4"
$table_name = "CCYV4_DG0"

$queryPartition=@"
select 'select count(1) from CCYV4.' || table_name || ' partition( ' || partition_name || ' )' 
from dba_tab_partitions
where table_owner = '$owner'
and table_name = '$table_name'
"@

$PartitionCount = "select count(1) PartCount from dba_tab_partitions where table_owner='$owner' and table_name='$table_name' "

$results = Get-OraResultDataTable -conString $connStr -sqlString $queryPartition -Verbose 


# Combining Dynamic Sql queries as one combined Final Query 
$finalQry = "select "
foreach($res in $results){
    write-host "Partition Query=> " $res[0]
    $finalQry += "(" + $res[0] + "), `n"
}

$finalQry += "(" + $PartitionCount + " ) `n from dual"


$results = Get-OraResultDataTable -conString $connStr -sqlString $finalQry -Verbose 
