# Setting Environment Variables without mentioning Machine or User context
[Environment]::SetEnvironmentVariable("PYTHONPATH" , "C:\Users\farooq.GENIE\AppData\Local\Programs\Python\Python36")

# Setting Environment Variables with Machine context
[Environment]::SetEnvironmentVariable("ORACLE_HOME" , "D:\ORACLE\product\11.2.0\dbhome_1","Machine")
[Environment]::SetEnvironmentVariable("ORACLE_SID" , "orcl" ,"Machine" )

# Setting Environment Variables with User context
[Environment]::SetEnvironmentVariable("JAVA_HOME" , "C:\Program Files\Java\" , "User" )

# Getting Environment Variables with User context
[Environment]::GetEnvironmentVariable("JAVA_HOME", "User")
