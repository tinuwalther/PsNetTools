# PsNetTools
PowerShell Networking Tools as Class

## Dig
dig - domain information groper.  
Resolves a host name to his IP addresses.   

````
PS /> [PsNetTools]::dig('sbb.ch')

TargetName IpV4Address     IpV6Address
---------- -----------     -----------
sbb.ch     194.150.245.142 2a00:4bc0:ffff:ffff::c296:f58e
````

## Tping
tping - tcp port scanner.  
It's like the cmdlet Test-NetConnection, but with the ability to specify a timeout in ms.  

````
PS /> [PsNetTools]::tping('sbb.ch', 80, 100)

TargetName TcpPort TcpSucceeded MaxTimeout
---------- ------- ------------ ----------
sbb.ch          80         True 100ms
````

## Uping
uping - udp port scanner.  
It's like the cmdlet Test-NetConnection, but with the ability to specify a timeout in ms and query for udp.  

````
PS /> [PsNetTools]::uping('sbb.ch', 53, 100)

TargetName UdpPort UdpSucceeded MaxTimeout
---------- ------- ------------ ----------
sbb.ch          53         True 100ms
````

## Wping
wping - http web request scanner.  
It's like the cmdlet Invoke-WebRequest, but with the ability to specify 'noproxy' with PowerShell 5.1.  

````
PS /> [PsNetTools]::wping('https://sbb.ch', 1000, 'noproxy') 

TargetName     ResponseUri            StatusCode MaxTimeout
----------     -----------            ---------- ----------
https://sbb.ch https://www.sbb.ch/de/         OK 1000ms
````
