function Set-PrtgDependencyType{

    <#

    .SYNOPSIS
    Changes the dependency type of an object

    .DESCRIPTION
    Changes the dependency type of an object

    .PARAMETER device
    PrtgAPI Device Object or Object array. Use Get-Device or Get-Group
    
    .PARAMETER dependency
    PrtgAPI Device Object. Use Get-Device or Get-Group

    .OUTPUTS
    Console output of changed dependency

    .NOTES
    Version:        1.1
    Author:         Noah Li Wan Po
    Creation Date:  19.10.2021
    Purpose/Change: Initial function development
  
    .EXAMPLE
    Set-PrtgDependencyType $device $dep

    .EXAMPLE
    Set-PrtgDependencyType -object $device -dependency $dep

    #>

    [CmdletBinding()]
    Param (
            [parameter(valuefrompipeline = $true, mandatory = $true, HelpMessage = "Object to set/change the dependency", Position = 0)]
            [PrtgAPI.SensorOrDeviceOrGroupOrProbe[]]$object,
            [parameter(valuefrompipeline = $true, mandatory = $true, HelpMessage = "Dependency Device", Position = 1)]
            [PrtgAPI.Sensor]$dependency        
        )

    BEGIN{ 

        $params = @{
            "scheduledependency" = 0
            "dependencytype_" = 1
            "dependency_" = $dependency.id
        }
        
    }
    PROCESS{ 

        $object | Set-ObjectProperty -RawParameters $params -Force 

        $setdependency = ($object | Get-ObjectProperty).PSObject.Properties | where {$_.name -like "dep*"} | select-object name,value
    }
    END{
    
        return $setdependency
    
    } 

}