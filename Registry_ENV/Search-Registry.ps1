# Search registry function based on a longer version from online available Search-Register function
function Search-Registry { 
    param( 
        [Parameter(Mandatory)] 
        [string[]] $Path, 
        [switch] $Recurse, 
        [Parameter()] 
        [string] $ValueNameRegex 
    ) 
    process { 
        foreach ($CurrentPath in $Path) { 
                    Get-ChildItem $CurrentPath -Recurse |  
                        ForEach-Object { 
                            $Key = $_ 
                            $KeyParent =  $Key | split-path -parent | Split-Path -Leaf
                            $KeyLeaf = $Key |  Split-Path -Leaf

                            if ($KeyNameRegex) {  
                                Write-Verbose ("{0}: Checking KeyNamesRegex" -f $Key.Name)  
                                if ($Key.PSChildName -match $KeyNameRegex) {  
                                    Write-Verbose "  -> Match found!" 
                                    return [PSCustomObject] @{ 
                                        Key = $Key 
                                        Reason = "KeyName"   }             }  
                            } 
         
                            if ($ValueNameRegex) {  
                                Write-Verbose ("{0}: Checking ValueNamesRegex" -f $Key.Name)                                 
                                if ($Key.GetValueNames() -match $ValueNameRegex) {  
                                    Write-Verbose "  -> Match found!" 
                                    return [PSCustomObject] @{ 
                                        Key = $KeyParent
                                        Child = $KeyLeaf
                                        Value  = $Key.GetValue("JavaHome")
                                        Reason = "ValueName" }                    }  
                            } 
                       } # foreach-object end
              } # foreach $path end
    }
} # function end

$key = "HKLM:\SOFTWARE\JavaSoft"

$vals = Search-Registry -Path $key -Recurse -ValueNameRegex "JavaHome*" -Verbose

$vals | select Key, Child, Value
