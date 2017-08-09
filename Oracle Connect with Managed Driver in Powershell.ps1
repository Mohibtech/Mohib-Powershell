
Add-Type -Path "C:\Oracle\ODAC\ODAC 12c\odp.net\managed\common\Oracle.ManagedDataAccess.dll"
$username = "hr"
$password = "hr"
$datasource = "localhost/far.domain.com"

$constr='User Id=' + $username + ';Password=' + $password + ';Data Source=' + $datasource

$con = New-Object Oracle.ManagedDataAccess.Client.OracleConnection($constr)
$con.open()

$cmd=$con.CreateCommand()
$cmd.CommandText="SELECT * FROM FAR.SALES_DUP"

$ds = New-Object system.Data.DataSet
$da = New-Object Oracle.ManagedDataAccess.Client.OracleDataAdapter($cmd)
$da.fill($ds)

$ds.Tables[0] 

$con.Close()
