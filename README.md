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
