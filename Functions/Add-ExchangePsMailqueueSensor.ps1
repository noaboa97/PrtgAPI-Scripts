function  Add-ExchangePsMailqueueSensor{
    Param (
            [parameter(valuefrompipeline = $true, HelpMessage = "PRTG Device Object", Position = 0)]
            [PrtgAPI.Device]$device,
            [parameter(valuefrompipeline = $true, HelpMessage = "Enter logfile path", Position = 1)]
            [string]$logfile = "C:\Scripts\PRTG\Logs\LOG_Add-ExchangePsDatabaseDAGSensor.txt"
        )

    If (!(Test-Path $logfile)) {New-Item -Path $logfile -Force}
       

    if($logfile -eq "C:\Scripts\PRTG\Logs\LOG_Add-ExchangePsDatabaseDAGSensor.txt"){
        Add-content -path $logfile  -Value "$(get-date -Format "dd.MM.yyyy_HH.mm.ss"): -------------------------------Adding PS Exchange Mailqueue sensor to $($device.name)-------------------------------"
    }
    else{

        Add-content -path $logfile  -Value "$(get-date -Format "dd.MM.yyyy_HH.mm.ss"): -------------------------------PS Exchange Mailqueue sensor-------------------------------"

    }

    #Get the interfaces of the device which are dynamic per device
    Write-Host "Loading targets"
    Add-content -path $logfile  -Value "$(get-date -Format "dd.MM.yyyy_HH.mm.ss"): Loading targets"
    try{
        $targets = $device | get-sensortarget -rawType exchangepsmailqueue -Timeout 5000 -ErrorAction Stop 
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

        Add-content -path $logfile  -Value "$(get-date -Format "dd.MM.yyyy_HH.mm.ss"): Creating sensor for Exchange DB $($targets[$i].name)"
        $target = $targets[$i].properties -join "|"
        $i ++

        $table = @{
            "name_"="Base Sensor"
            "tags_"="exchange powershell mailqueue"
            "priority_"=3
            "elementlist_"=1
            "elementlist__check"=$target
            "remount"=0
            "writeresult"=0
            "intervalgroup"=0
            "interval_"="300|5 minutes"
            "errorintervalsdown_"=1
            "inherittriggers"=1
            "id"=$device.id
            "sensortype"="exchangepsmailqueue"
        }

        $params = New-SensorParameters $table

        Get-Device -id $device.id | Add-Sensor $params
    }

}
