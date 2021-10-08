function Set-PrtgMaintenanceWindow{
    [CmdletBinding()]
    Param (
            [parameter(valuefrompipeline = $true, mandatory = $true, HelpMessage = "Device to set the maintenance window", Position = 0)]
            [PrtgAPI.Device]$device,
            [parameter(valuefrompipeline = $true, mandatory = $true, HelpMessage = "Start date and time of the maintenance window", Position = 1)]
            [string]$start,
            [parameter(valuefrompipeline = $true, mandatory = $true, HelpMessage = "End date and time of the maintenance window", Position = 2)]
            [string]$end            
        )

    BEGIN{ 
        
    }
    PROCESS{ 

        $params = @{
            "scheduledependency" = 0
            "maintenable_" = 1
            "maintstart_" = $start
            "maintend_" = $end
        }

        $device | Set-ObjectProperty -RawParameters $params -Force 

        $maintenace = ($device | Get-ObjectProperty).PSObject.Properties | where {$_.name -like "maint*"} | select-object name,value
    }
    END{
    
        return $maintenace
    
    } 

}