# PrtgAPI-Scripts
PRTG Scripts and custom functions for the [PrtgAPI](https://github.com/lordmilko/PrtgAPI)

## Functions

### Add-SNMPTrafficSensor

Adds the SNMP traffic sensors to a specific device.
```powershell
Add-SNMPTrafficSensor
   [[-device] <PrtgAPI.Device[]>]
   [[-propertiesfilter]<string[]>]
   [[-valuefilter]<string[]>]
   [[-logfile]<string[]>]
   [<CommonParameters>]
```
<br/>

**-propertiesfilter** <br>
The properties contain: Internal name, Name, Status, speed as an array and will filter based on the string provided.
<br/>
<br/>

**-valuefilter**<br>
The value contains the name and will filter based on the string provided. If you don't wanna filter put a wildcard. Also use Wildcards with the search string if you just wanna filter on some characters. 
<br/>
<br/>

```powershell
Add-SNMPTrafficSensor $device "Connected" "*Uplink*" $logfile
```
Add all interfaces which are connected and the description of the port contains "Uplink" and specify an own logfile path.

#### TO DO:
- make settings customizable
- Synopsis
- Comment code


### Add-SNMPCiscoSystemHealth

### New-PrtgUsergroup

It uses the session created from ```get-prtgclient```.
Use ```Connect-PrtgServer``` to connect to your server
```powershell
Add-SNMPTrafficSensor
   [[-name] <string[]>]
   [[-defaulthome]<string[]>]
   [[-string]<string[]>]
   [[-isadmingroup]<int[]>]
   [[-isadgroup]<int[]>]
   [[-adgroup]<int[]>]
   [[-usertype]<int[]>]
   [[-userack]<int[]>]
   [[-allowedsensorsmode]<int[]>]
   [[-ticketmode]<int[]>]
   [<CommonParameters>]
```       
 
        
**-name**<br/>
PRTG User Group Name<br/>
<br/>
**-isadmingroup**<br/>
Administrative Rights<br/>
0 - Do not give user group members administrative rights (default)<br/>
1 - Give user group members administrative rights<br/>
<br/>
**defaulthome**       <br/>
PRTGHome Page URL<br/>
<br/>
**-isadgroup**  <br/>
Active Directory or Single Sign-On Integration<br/>
0 - Do not use Active Directory or single sign-on integration (default)<br/>
1 - Use Active Directory integration<br/>
2 - Use single sign-on integration (not supported)<br/>
<br/>
**-ssogroupaccessclaim (not supported)**<br/>
Haven't been able to checkout SSO. So currently not supported. You could edit the function directly.    <br/>
<br/>
**-adgroup**<br/>
Active Directory Group Name<br/>
<br/>
**-usertype**<br/>
User Type<br/>
0 - Read/write user (default)<br/>
1 - Read-only user<br/>
<br/>
**-userack**<br/>
Acknowledge Alarms<br/>
0 - User cannot acknowledge alarms (default)<br/>
1 - User can acknowledge alarms<br/>
<br/>
**-allowedsensorsmode**<br/>
Allowed Sensors<br/>
0 - Users can create all sensors (default)<br/>
1 - Users can only create certain sensors<br/>
Currently not supported to choose which sensors<br/>
<br/>
**-ticketmode**    <br/>
0 - Users cannot use the ticket system (default)<br/>
1 - Users can use the ticket system<br/>
<br/>
<br/>
To create a new group with AD integration and Read-only<br/>
**Example**
```powershell
New-PrtgUsergroup -name Test123  -isadgroup 1 -adgroup YOURADGROUP -usertype 1
```




