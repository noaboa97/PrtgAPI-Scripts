function Add-SNMPCiscoSystemHealth{

    <#

    .SYNOPSIS
    Creates the SNMP Cisco System Health sensor 

    .DESCRIPTION
    Uses the PRTG API to create the SNMP Cisco System Health sensor 

    .PARAMETER MCUsername
    Username of the local MobiControl account with administrator rights

    .PARAMETER device
    PrtgAPI Device Object. Use Get-Device

    .PARAMETER Logfile
    Standard path for the logfile. Will create the path if not existent. 
    C:\Scripts\PRTG\Logs\LOG_Add-SNMPTrafficSensor.txt

    .OUTPUTS
    Console output and logfile

    .NOTES
    Version:        1.0
    Author:         Noah Li Wan Po
    Creation Date:  04.11.2020
    Purpose/Change: Initial function development
  
    .EXAMPLE
    Add-SNMPCiscoSystemHealth $device $logfile

    .EXAMPLE
    Add-SNMPCiscoSystemHealth $device "C:\Logs\Log.txt"

    .EXAMPLE
    Add-SNMPCiscoSystemHealth -device $device -logfile $logfile

    #>

    Param (
            [parameter(valuefrompipeline = $true, HelpMessage = "PRTG Device Object", Position = 0)]
            [PrtgAPI.Device]$device,
            [parameter(valuefrompipeline = $true, HelpMessage = "Enter logfile path", Position = 1)]
            [string]$logfile = "C:\Scripts\PRTG\Logs\LOG_Add-SNMPTrafficSensor.txt"
        )

    # Test if logfile and path are there otherwise creates it
    If (!(Test-Path $logfile)) {New-Item -Path $logfile -Force}
       
    # Diffrent log output depending if logfilepath is standard or not
    if($logfile -eq "C:\Scripts\PRTG\Logs\LOG_Add-SNMPTrafficSensor.txt"){

        Add-content -path $logfile  -Value "$(get-date -Format "dd.MM.yyyy_HH.mm.ss"): -------------------------------Adding SNMP Cisco system health sensor to $($device.name)-------------------------------"
    
    }
    else{

        Add-content -path $logfile  -Value "$(get-date -Format "dd.MM.yyyy_HH.mm.ss"): -------------------------------SNMP traffic sensor-------------------------------"

    }

    
    Write-Host "Loading targets"
    Add-content -path $logfile  -Value "$(get-date -Format "dd.MM.yyyy_HH.mm.ss"): Loading targets"

    # Get the interfaces of the device which are dynamic per device
    try{

        $targets = $device | get-sensortarget -rawType snmpciscosystemhealth -Timeout 5000 -ErrorAction Stop 

    }
    catch{
        
        # Writer error to logfile
        Add-content -path $logfile -Value "$(get-date -Format "dd.MM.yyyy_HH.mm.ss"): $($_)"
        return

    }

    if($targets -eq $null){
    
        # If there are no targets available write to console and logfile and exit the function
        Write-Host "No targets found"
        Add-Content -path $logfile  -Value "$(get-date -Format "dd.MM.yyyy_HH.mm.ss"): No targets found"
        return
    
    }

    
    Write-Host "Creating Sensors"
    Add-content -path $logfile  -Value "$(get-date -Format "dd.MM.yyyy_HH.mm.ss"): Creating Sensors"

    $i = 0

    # For each target create a new sensor. 
    foreach($target in $targets){

        Add-content -path $logfile  -Value "$(get-date -Format "dd.MM.yyyy_HH.mm.ss"): Creating sensor for system health $($targets[$i].name)"
        $target = $targets[$i].properties -join "|"
        $i ++

        $table = @{
            "name_"="Base Sensor"
            "parenttags_"="vendors_Cisco"
            "tags_"="snmpciscosystemhealthsensor systemhealth"
            "priority_"=3
            "measurement_"=1
            "measurement__check"=$target
            "intervalgroup"=0
            "interval_"="300|5 minutes"
            "errorintervalsdown_"=1
            "inherittriggers"=1
            "id"=$device.id
            "sensortype"="snmpciscosystemhealth"
        }

        # Create new sensor parameters
        $params = New-SensorParameters $table

        # Add the sensors to the device
        Get-Device -id $device.id | Add-Sensor $params

    }
    
   
    # Get the sensors specified and remove them
    get-sensor -Device $device -Tag Snmpciscosystemhealthsensor | where {$_.name -like "*voltages" -or $_.name -like "*other" -or $_.name -like "*currents" } | remove-object -force
    
    # Logfile 
    Write-Host "Removed sensors: voltages, other and currents"
    Add-content -path $logfile  -Value "$(get-date -Format "dd.MM.yyyy_HH.mm.ss"): Removed sensors: voltages, other and currents"


}
