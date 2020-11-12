# PrtgAPI-Scripts
PRTG Scripts and custom functions for the [PrtgAPI](https://https://github.com/lordmilko/PrtgAPI)

## Functions

### Add-SNMPTrafficSensor

**Adds the SNMP traffic sensors to a specific device.**
```powershell
Add-SNMPTrafficSensor
   [[-device] <PrtgAPI.Device[]>]
   [[-propertiesfilter]<string[]>]
   [[-valuefilter]<string[]>]
   [[-logfile]<string[]>]
   [<CommonParameters>]
```
<br/>
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

