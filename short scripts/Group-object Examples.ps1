# Grouping results based on Extension property filtered on Name
ls c:\WINDOWS\TEMP | Group -Property Extension 

# Grouping results based on Extension property filtered on Name
ls c:\WINDOWS\TEMP | Group -Property Extension | where Name -like .txt #| select Group |Format-List

# Grouping results based on Extension property without Group elements
ls c:\WINDOWS\TEMP | Group -Property Extension -NoElement
