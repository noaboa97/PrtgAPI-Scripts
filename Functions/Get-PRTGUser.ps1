function Get-PrtgUser{

    <#
    .SYNOPSIS
    Retreives all PRTG user accounts with basic information

    .DESCRIPTION
    Retreives all PRTG user accounts with basic information by scraping the returned HTML table of the PRTG Webinterface user overview
    Afaik there is no API v1 Endpoint for that.

    This Function is dependent on PrtgAPI PowerShell Module from lordmilko

    .PARAMETER None
    Currently there are no Parameters for this function
    Maybe filterin in the future, but anyways would still need to parse the whole html

    .OUTPUTS
    Array of PSCustomObject

    .EXAMPLE
    $result = Get-PrtgUser 

    .NOTES
    Version: 1.0
    CreateDate:  13.10.2023
    Author:     Noah Li Wan Po
    ModifyDate: 16.10.2023
    ModifyUser: Noah Li Wan Po
    Purpose/Change: Initial function development
    #>

    BEGIN{

        if(-not (Get-Module PrtgAPI)){
            Write-Error -Message "Please install PrtgAPI by Lordmilko Command: Install-Module PrtgAPI"
        }

        $session = Get-prtgclient
        if(-not $session){
            Write-Error -Message "Please login to a PRTG server first. Command: Connect-PrtgServer"
        }

        $Header = @{}
        $Header["X-Requested-With"] = "XMLHttpRequest" 

    }

    PROCESS{
        Try{
            $response = Invoke-webrequest -Uri "https://$($session.server)/controls/table.htm?tableid=usertable&content=users&columns=name%2Ctype%2Cemail%2Cprimarygroup%2Cgroupmemberships%2Cactive%2Ccheckbox&tools=delete%2Cedit%2Cpause&count=500&sortby=name&sortable=true&links=true&refreshable=true&tabletitle=Benutzer&varexpand=tabletitle&username=$($session.UserName)&passhash=$($session.PassHash)" -Headers $Header 
        }catch{
            throw "An Error occured `n $_"
        }
        
        $htmldoc = $response.ParsedHtml

        # Find the table using the class attribute
        $table = $htmlDoc.getElementById('table_usertable')

        # Check if the table is found
        if ($null -eq $table) {
            Write-Host "Table not found."
        } else {
            # Extract rows from the table
            $rows = $table.getElementsByTagName('tr')

            $UserList = @()

            # Iterate through rows and extract data
            foreach ($row in $rows) {
                if($row.getElementsByTagName('td')[0].innerText){
                    $obj = [pscustomobject]@{

                        Id = $row.childNodes[0].children[0].id
                        DisplayName = $row.getElementsByTagName('td')[0].innerText
                        Type = $row.getElementsByTagName('td')[1].innerText
                        Email = $row.getElementsByTagName('td')[2].innerText
                        Primarygroup = $row.getElementsByTagName('td')[3].innerText
                        Othergroups = $row.getElementsByTagName('td')[4].innerText
                        Status = $row.getElementsByTagName('td')[5].innerText

                    }
                }

                $UserList += $obj
                
            }
        }
    }

    END{
        return $userlist
    }
}