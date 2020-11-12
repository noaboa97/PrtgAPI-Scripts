function Add-SNMPTrafficSensor{
    Param (
            [parameter(valuefrompipeline = $true, HelpMessage = "PRTG Device Object", Position = 0)]
            [PrtgAPI.Device]$device,
            [parameter(valuefrompipeline = $true, mandatory = $true, HelpMessage = "Enter filter for properties", Position = 1)]
            [string]$propertiesfilter,
            [parameter(valuefrompipeline = $true, mandatory = $true, HelpMessage = "Enter filter for value", Position = 2)]
            [string]$valuefilter,
            [parameter(valuefrompipeline = $true, HelpMessage = "Enter logfile path", Position = 3)]
            [string]$logfile = "C:\Scripts\PRTG\Logs\LOG_Add-SNMPTrafficSensor.txt"

        )

    If (!(Test-Path $logfile)) {New-Item -Path $logfile -Force}

    if($logfile -eq "C:\Scripts\PRTG\Logs\LOG_Add-SNMPTrafficSensor.txt"){
        Add-content -path $logfile  -Value "$(get-date -Format "dd.MM.yyyy_HH.mm.ss"): -------------------------------Adding SNMP traffic sensor to $($device.name)-------------------------------"
    }
    else{

        Add-content -path $logfile  -Value "$(get-date -Format "dd.MM.yyyy_HH.mm.ss"): -------------------------------SNMP traffic sensor-------------------------------"

    }

    #Get the interfaces of the device which are dynamic per device
    Write-Host "Loading targets"
    Add-content -path $logfile  -Value "$(get-date -Format "dd.MM.yyyy_HH.mm.ss"): Loading targets"
    try{
        $targets = $device | get-sensortarget -rawType snmptraffic -Timeout 5000 -ErrorAction Stop | where {$_.Properties -contains $propertiesfilter -and $_.Value -like $valuefilter}
    }
    catch{
    
        Add-content -path $logfile -Value "$(get-date -Format "dd.MM.yyyy_HH.mm.ss"): $($_)"
        return
    
    }

    if($targets -eq $null){
    
        Write-Host "No targets found"
        Add-Content -path $logfile  -Value "$(get-date -Format "dd.MM.yyyy_HH.mm.ss"): No targets found"
        return
    
    }


    $i = 0
    Write-Host "Creating Sensors"
    Add-content -path $logfile  -Value "$(get-date -Format "dd.MM.yyyy_HH.mm.ss"): Creating Sensors"
    foreach($target in $targets){
        
        Add-content -path $logfile  -Value "$(get-date -Format "dd.MM.yyyy_HH.mm.ss"): Creating sensor for interface $($targets[$i].name)"
        $target = $targets[$i].properties -join "|"
        $i ++

        $table = @{
            "name_"="Base Sensor"
            "tags_"="bandwidthsensor snmptrafficsensor"
            "priority_"=3
            "interfacenumber_"=1
            "interfacenumber__check"=$target
            "trafficmode_"="errors"
            "monitorstate_"=0
            "namein_"="Traffic In"
            "nameout_"="Traffic Out"
            "namesum_"="Traffic Total"
            "stack_"=0
            "intervalgroup"=1
            "errorintervalsdown_"=1
            "inherittriggers"=1
            "id"=$device.id
            "sensortype"="snmptraffic"
        }

        $params = New-SensorParameters $table

        Get-Device -id $device.id | Add-Sensor $params
    }
}
