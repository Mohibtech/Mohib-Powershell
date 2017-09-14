# Counting Partition Row Counts of Tables for existing and migrated server.


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

function ResultSet{
    [CmdLetBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [object]$servers,
        [Parameter(Mandatory=$true)]
        [string]$tblOwner,
        [Parameter(Mandatory=$true)]
        [string]$tblName
    )
    begin {
        $results=@()
        $owner = $tblOwner
        $table_name = $tblName
    }
    process {
        try{
            foreach ($server in $servers){
                $srvrname = $server.'name'
                $datasource = $srvrname + '/' + $server.'service' 
                $username = $server.'user'
                $passwd = $server.'password'
    
                write-verbose "$srvrname $datasource $user $passwd    "
                write-verbose "##################################"
                $connStr="User Id=$username;Password=$passwd;Data Source=$datasource"

                write-verbose "SQL Query $sqlquery " 
                

$queryPartition=@"
                select '(select count(1) from $owner.' || table_name || ' partition( ' || partition_name || ' )) PT_'|| substr(partition_name,-8)
                from dba_tab_partitions
                where table_owner = '$owner'
                and table_name = '$table_name'
"@

                write-verbose "Partition query  $queryPartition "

                $PartitionCount = "select count(1) PartCount from dba_tab_partitions where table_owner='$owner' and table_name='$table_name' "
                
                # Dynamic SQL results with query in an array
                $qryResults = Get-OraResultDataTable -conString $connStr -sqlString $queryPartition -Verbose 

                # Combining Dynamic Sql queries as one combined Final Query 
                $finalQry = "select "
                $Machine = "(SELECT MACHINE FROM V`$SESSION WHERE SID = 1) MACHINE" + ", `n"
                $TableName = "(select table_name from dba_tables where table_name = '$table_name') TBL_NAME" + ", `n"

                $finalQry += $Machine + $TableName
                foreach($res in $qryResults){
                    #write-host "Partition Query=> " $res[0]
                    $finalQry += $res[0] + ", `n"
                }

                $finalQry += "(" + $PartitionCount + ") PT_Count `n from dual"

                # Retrieving query results from Oracle in a Data set
                $results += Get-OraResultDataTable -conString $connStr -sqlString $finalQry -Verbose 
                                 
                }
        }
        catch{
            Write-Error($_.Exception.ToString())
        }
    }
    end {
        $results
    }

}

$srvrs = Import-Csv -Path "D:\Backup\Oracle\IDM\servers.txt"

$owner = "CCYV4"
$tables = @("CCYV4_DG0","CCYV4_DG1","CCYV4_DG2")

$AccumResults=@()

foreach ($table in $tables){
    Write-Host "Table $table"
    $AccumResults += ResultSet -servers $srvrs -tblOwner $owner -tblName $table -Verbose
}


$expCSV = "D:\Backup\Oracle\IDM\CCY4_PartRowCounts.csv"
$AccumResults | Export-CSV $expCSV -NoTypeInformation   
