# PsNetTools

PsNetTools is a cross platform PowerShell module to test some network features on Windows and Mac.  

## Usage

Import Module:  

````powershell
Import-Module .\PsNetTools.psd1 -Force
````

List all ExportedCommands:  

````powershell
Get-Module PsNetTools

ModuleType Version    Name            ExportedCommands
---------- -------    ----            ----------------
Script     0.1.0      PsNetTools      {PsNetDig, PsNetTping, PsNetUping, PsNetWping}
````

## PsNetDig

dig - domain information groper.  
Resolves a hostname to his IP addresses or an IP Address to his hostname.  

### Get-Help PsNetDig

PsNetDig -Destination

- Destination: Hostname | IP Address | Alias | WebUrl

### Example PsNetDig

````
PS /> PsNetDig -Destination 'sbb.ch'

TargetName IpV4Address     IpV6Address
---------- -----------     -----------
sbb.ch     194.150.245.142 2a00:4bc0:ffff:ffff::c296:f58e
````

## PsNetTping

tping - tcp port scanner.  
It's like the cmdlet Test-NetConnection, but with the ability to specify a timeout in ms.  

### Get-Help PsNetTping

PsNetTping -Destination -TcpPort -Timeout

- Destination: Hostname | IP Address | Alias | WebUrl
- TcpPort:     Tcp Port to use
- Timeout:     Timeout in ms

### Example PsNetTping

````
PS /> PsNetTping -Destination 'sbb.ch' -TcpPort 443 -Timeout 100

TargetName TcpPort TcpSucceeded MaxTimeout
---------- ------- ------------ ----------
sbb.ch         443         True 100ms
````

## PsNetUping

uping - udp port scanner.  
It's like the cmdlet Test-NetConnection, but with the ability to specify a timeout in ms and query for udp.  

### Get-Help PsNetUping

PsNetTping -Destination -UdpPort -Timeout

- Destination: Hostname | IP Address | Alias | WebUrl
- UdpPort:     Udp Port to use
- Timeout:     Timeout in ms

### Example PsNetUping

````
PS /> PsNetUping -Destination 'sbb.ch' -UdpPort 53 -Timeout 100

TargetName UdpPort UdpSucceeded MaxTimeout
---------- ------- ------------ ----------
sbb.ch          53         True 100ms
````

## PsNetWping

wping - http web request scanner.  
It's like the cmdlet Invoke-WebRequest, but with the ability to specify 'noproxy' with PowerShell 5.1.  

### Get-Help PsNetWping

PsNetWping -Destination -Timeout [-NoProxy]

- Destination: WebUri
- Timeout:     Timeout in ms
- NoProxy:     Switch

### Example PsNetWping

````
PS /> PsNetWping -Destination 'https://sbb.ch' -Timeout 1000 -NoProxy

TargetName     ResponseUri            StatusCode MaxTimeout
----------     -----------            ---------- ----------
https://sbb.ch https://www.sbb.ch/de/         OK 1000ms
````
