function Set-PrtgMaintenanceWindow{

    <#

    .SYNOPSIS
    Adds a maintenance window to a PRTG device

    .DESCRIPTION
    Adds a maintenance window to a PRTG device


    .PARAMETER device
    PrtgAPI Device Object. Use Get-Device

    .PARAMETER start
    Start time of the maintenance window
    Format: YYYY-MM-DD-hh-mm-ss

    .PARAMETER start
    End time of the maintenance window
    Format: YYYY-MM-DD-hh-mm-ss

    .OUTPUTS
    Console output of the added maintenance window

    .NOTES
    Version:        1.0
    Author:         Noah Li Wan Po
    Creation Date:  08.10.2021
    Purpose/Change: Initial function development
  
    .EXAMPLE
    Set-PrtgMaintenanceWindow $device "2021-10-08-12-57-00" "2021-10-08-13-00-00"

    .EXAMPLE
    Set-PrtgMaintenanceWindow -device $device -start "2021-10-08-12-57-00" -end "2021-10-08-13-00-00"

    #>

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

        $params = @{
            "scheduledependency" = 0
            "maintenable_" = 1
            "maintstart_" = $start
            "maintend_" = $end
        }
        
    }
    PROCESS{ 

        $device | Set-ObjectProperty -RawParameters $params -Force 

        $maintenace = ($device | Get-ObjectProperty).PSObject.Properties | where {$_.name -like "maint*"} | select-object name,value
    }
    END{
    
        return $maintenace
    
    } 

}