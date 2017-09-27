# Multiple Short scripts

# Getting List of Processes (Programs) using 20 MB or more
Get-Process | Where-Object { $_.WS -ge 20MB }


# Storing process result in variable using the variable parameter
Get-Process notepad | Tee-Object -variable victims | Stop-Process
$victims | select ProcessName,HasExited

# Stopping Process IDMIntegrator
Get-Process | Where { $_.ProcessName -like "idm*" } | Stop-Process

# Group Object by Status
Get-Service | Group-Object Status

# Group Object by Status and displaying Stopped Services
(Get-Service | Group-Object Status)[0].Group

