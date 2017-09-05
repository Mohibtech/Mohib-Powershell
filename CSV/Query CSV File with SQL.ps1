$provider = (New-Object System.Data.OleDb.OleDbEnumerator).GetElements() | 
             Where { $_.SOURCES_NAME -like "Microsoft.ACE.OLEDB.*" }

if ($provider -is [system.array]) { $provider = $provider[0].SOURCES_NAME } 
else {  $provider = $provider.SOURCES_NAME }

$csv = "$env:TEMP\top-tracks.csv"
$connStr = "Provider=$provider;Data Source=$(Split-Path $csv);Extended Properties='text;HDR=$firstRowColumnNames;';"

Invoke-WebRequest http://git.io/vvzxA | Set-Content -Path $csv

$firstRowColumnNames = "Yes"
$delimiter = ","

# If delimiter is other than comma then use schema.ini 
if ($delimiter -ne ",") {
   $filename = Split-Path $csv –leaf
   Set-Content -Path schema.ini -Value "[$filename]"
   Add-Content -Path schema.ini -Value "Format=Delimited($delimiter)"
}

$tablename = (Split-Path $csv -leaf).Replace(".","#")

$sql = "SELECT TOP 20 SUM(playcount) AS playcount, artist from [$tablename] 
       WHERE artist <> 'Fall Out Boy' 
       GROUP BY artist 
       HAVING SUM(playcount) > 4 
       ORDER BY SUM(playcount) DESC, artist"


$conn = New-Object System.Data.OleDb.OleDbconnection
$conn.ConnectionString = $connStr
$conn.Open()

$cmd = New-Object System.Data.OleDB.OleDBCommand
$cmd.Connection = $conn

$cmd.CommandText = $sql

# Load into datatable
$dt = New-Object System.Data.DataTable
$dt.Load($cmd.ExecuteReader("CloseConnection"))

# Clean up
$cmd.dispose | Out-Null; $conn.dispose | Out-Null

# Output results
$dt | Format-Table -AutoSize
