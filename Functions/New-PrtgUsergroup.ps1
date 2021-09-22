function New-PrtgUsergroup{
    [CmdletBinding()]
    Param (
            [parameter(valuefrompipeline = $true, mandatory = $true, HelpMessage = "PRTG groupname", Position = 0)]
            [string]$name,
            [parameter(valuefrompipeline = $true, HelpMessage = "Administrative Rights", Position = 1)]
            [int]$isadmingroup = 0,
            [parameter(valuefrompipeline = $true, HelpMessage = "Home Page URL", Position = 2)]
            [string]$defaulthome = "/welcome.htm",
            [parameter(valuefrompipeline = $true, HelpMessage = "Use Active Directoriy integration")]
            [int]$isadgroup = 0,
            [parameter(valuefrompipeline = $true, HelpMessage = "AD Group name")]
            [string]$adgroup,
            [parameter(valuefrompipeline = $true, HelpMessage = "Read/write user (0) or Read-only user (1)")]
            [int]$usertype = 0,
            [parameter(valuefrompipeline = $true, HelpMessage = "cannot acknowledge alarms (default) (0) or acknowledge alarms (1)")]
            [int]$userack = 0,
            [parameter(valuefrompipeline = $true, HelpMessage = "can create all sensors (0) or can only create certain sensors")]
            [int]$allowedsensorsmode = 0,
            [parameter(valuefrompipeline = $true, HelpMessage = "cannot use the ticket system (0) or can use the ticket system")]
            [int]$ticketmode = 0
            
        )

    $sessions = Get-prtgclient

    $Header = @{}
    $Header["X-Requested-With"] = "XMLHttpRequest"   

    $oname                     = New-Object PSCustomObject @{name_                   = $name}
    $oisadmingroup             = New-Object PSCustomObject @{isadmingroup_           = $isadmingroup}
    $odefaulthome              = New-Object PSCustomObject @{defaulthome_            = $defaulthome}
    $oisadgroup                = New-Object PSCustomObject @{isadgroup_              = $isadgroup}
    $ossogroupaccessclaim      = New-Object PSCustomObject @{ssogroupaccessclaim_    = ""}
    $oadgroup                  = New-Object PSCustomObject @{adgroup_                = $adgroup}
    $ousertype                 = New-Object PSCustomObject @{adusertype_             = $usertype}
    $ouserack                  = New-Object PSCustomObject @{aduserack_              = $userack}
    $oallowedsensorsmode       = New-Object PSCustomObject @{allowedsensorsmode_     = $allowedsensorsmode}
    $oallowedsensors           = New-Object PSCustomObject @{allowedsensors_         = 1}
    $oticketmode               = New-Object PSCustomObject @{ticketmode_             = $ticketmode}
    $ousers                    = New-Object PSCustomObject @{users_                  = 1}
    $oobjecttype               = New-Object PSCustomObject @{objecttype              = "usergroup"}
    $oid                       = New-Object PSCustomObject @{id                      = "new"}
      
    $Objects = New-Object 'System.Collections.Generic.List[pscustomobject]'
    $Objects.Add($oname)
    $Objects.Add($oisadmingroup)
    $Objects.Add($odefaulthome)
    $Objects.Add($oisadgroup)
    $Objects.Add($ossogroupaccessclaim)
    $Objects.Add($oadgroup)
    $Objects.Add($ousertype)
    $Objects.Add($ouserack)
    $Objects.Add($oallowedsensorsmode)
    $Objects.Add($oallowedsensors)
    $Objects.Add($oticketmode)
    $Objects.Add($ousers)
    $Objects.Add($oobjecttype)
    $Objects.Add($oid)
    $Objects.Add($otargeturl)

    $objects

    $boundary = [System.Guid]::NewGuid().ToString(); 
    $LF = "`r`n";

    $body = ""

    foreach($o in $Objects){
        $bodyLine = ( 
            "------$boundary",
            "Content-Disposition: form-data; name=`"$($o.keys)`"",
            "",
            "$($o.Values)$LF"           
        ) -join $LF 

        $body = $body + $bodyline
    }

    $body = $body + "------$boundary--$LF"

    $response = Invoke-restmethod -Uri "$($sessions.Server)/editsettings?username=$($sessions.UserName)&passhash=$($sessions.PassHash)" -contenttype "multipart/form-data; boundary=------$boundary" -Method POST -Headers $Header -Body $Body

    return $response

}