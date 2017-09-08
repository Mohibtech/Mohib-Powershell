# Compare Results of same query on existing and Migrated Server

function Get-OraResultDataTable{
    [CmdLetBinding()]
    param(
        [Parameter(Mandatory=$true)] 
        [string]$conString,
        [Parameter(Mandatory=$true)]
        [string]$sqlString
    )
    begin {  $resultSet=@() }
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
            if($con.State-eq'Open'){ $con.close() }
        }
    }
    end {  $resultSet  }
}

function ResultSet{
    [CmdLetBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [object]$servers,
        [Parameter(Mandatory=$false)]
        [string]$sqlquery
    )
    begin {
        $results=@()
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
                # Retrieving query results from Oracle in a Data set
                $results += Get-OraResultDataTable -conString $connStr -sqlString $sqlquery -Verbose 
                                 
                }
        }
        catch{ Write-Error($_.Exception.ToString())  }
    }
    end {         $results    }
}

# Servers.txt file format as follows
# Name,     Service, User,   Password
# localhost, orcl,   system, passwd
$srvrs = Import-Csv -Path "D:\Backup\Oracle\servers.txt"

$queryfiles = Get-ChildItem "D:\Backup\Oracle\GameStop\qry_DG*.txt"

foreach ($qfile in $queryfiles){
    write-host "################ $qfile ##################"
    $sqlquery = (Get-Content $qfile -Raw)
    $sqlquery
    $res = ResultSet -servers $srvrs -sqlquery $sqlquery -Verbose
    $res | Export-CSV "D:\Backup\Oracle\PartitionCounts.csv" -NoTypeInformation   
} 
