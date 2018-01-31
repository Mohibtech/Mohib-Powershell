#this will split Paths for both Machine and User 
$env:Path -split ';'
  ($env:Path).Split(";")

# Modifying Path Variable
# Removing entry from PATH variable
$path = [Environment ]::GetEnvironmentVariable('PATH' ,'User' )
$pathvar  = 'C:\Program Files\MongoDB\Server\3.4\bin'
$path = ($path. split(';') | Where { $_ -ne $pathvar }) -join ';'
[Environment]:: SetEnvironmentVariable('PATH', $path, 'User')

#Set Path variable with new path added
$pathvar  =  ';C:\Program Files\MongoDB\Server\3.4\bin'
[System.Environment]:: SetEnvironmentVariable('PATH', $env:path + $pathvar , 'User')

#Check if path is added while searching with keyword
$env:path -split ';' | Select-String -Pattern 'Mongo'


Removing Path from PATH Variable
# Get it
$path = [Environment]::GetEnvironmentVariable('PATH' ,'Machine')

# Remove unwanted elements
$remove = "'C:\data' "
$path = ($path.split(';') | Where { $_ -ne $remove  }) -join ';'

# Set it
[Environment]:: SetEnvironmentVariable('PATH', $path, 'Machine')
