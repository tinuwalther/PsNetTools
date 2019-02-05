# Table of Contents

- [Table of Contents](#table-of-contents)
- [PsNetTools](#psnettools)
- [Test-PsNetDig](#test-psnetdig)
- [Test-PsNetTping](#test-psnettping)
- [Test-PsNetUping](#test-psnetuping)
- [Test-PsNetWping](#test-psnetwping)
- [Get-PsNetAdapters](#get-psnetadapters)
- [Get-PsNetAdapterConfiguration](#get-psnetadapterconfiguration)
- [Get-PsNetRoutingTable](#get-psnetroutingtable)
- [Get-PsNetHostsTable](#get-psnethoststable)

# PsNetTools

PsNetTools is a cross platform PowerShell module to test some network features on Windows and Mac.  

![PsNetTools](./Images/PsNetTools.png)

Import Module:  

````powershell
Import-Module .\PsNetTools.psd1 -Force
````

List all ExportedCommands:  

````powershell
Get-Module PsNetTools

ModuleType Version Name       ExportedCommands
---------- ------- ----       ----------------
Script     0.1.2   PsNetTools {PsNetDig, PsNetTping, PsNetUping, PsNetWping}
````

# Test-PsNetDig

Test-PsNetDig - domain information groper.  
Resolves a hostname to the IP addresses or an IP Address to the hostname.  

Test-PsNetDig -Destination

- Destination: Hostname or IP Address or Alias or WebUrl

````powershell
Test-PsNetDig -Destination 'sbb.ch' | Format-List

TargetName  : sbb.ch
IpV4Address : 194.150.245.142
IpV6Address : 2a00:4bc0:ffff:ffff::c296:f58e
Duration    : 4ms
````

# Test-PsNetTping

Test-PsNetTping - tcp port scanner.  
It's like the cmdlet Test-NetConnection, but with the ability to specify a timeout in ms.  

Test-PsNetTping -Destination -TcpPort -Timeout

- Destination: Hostname or IP Address or Alias or WebUrl
- TcpPort:     Tcp Port to use
- Timeout:     Timeout in ms

````powershell
Test-PsNetTping -Destination 'sbb.ch' -TcpPort 443 -Timeout 100

TargetName   : sbb.ch
TcpPort      : 443
TcpSucceeded : True
Duration     : 22ms
MaxTimeout   : 100ms
````

# Test-PsNetUping

Test-PsNetUping - udp port scanner.  
It's like the cmdlet Test-NetConnection, but with the ability to specify a timeout in ms and query for udp.  

Test-PsNetTping -Destination -UdpPort -Timeout

- Destination: Hostname or IP Address or Alias or WebUrl
- UdpPort:     Udp Port to use
- Timeout:     Timeout in ms

````powershell
Test-PsNetUping -Destination 'sbb.ch' -UdpPort 53 -Timeout 100

TargetName   : sbb.ch
UdpPort      : 53
UdpSucceeded : False
Duration     : 103ms
MaxTimeout   : 100ms
````

# Test-PsNetWping

Test-PsNetWping - http web request scanner.  
It's like the cmdlet Invoke-WebRequest, but with the ability to specify 'noproxy' with PowerShell 5.1.  

Test-PsNetWping -Destination -Timeout [-NoProxy]

- Destination: WebUri
- Timeout:     Timeout in ms
- NoProxy:     Switch

````powershell
Test-PsNetWping -Destination 'https://sbb.ch' -Timeout 1000 -NoProxy

TargetName  : https://sbb.ch
ResponseUri : https://www.sbb.ch/de/
StatusCode  : OK
Duration    : 231ms
MaxTimeout  : 1000ms
````

# Get-PsNetAdapters

Get-PsNetAdapters -get the network interface for all adapters.  

````powershell
Get-PsNetAdapters | Where-Object Index -eq 11

Succeeded            : True
Index                : 11
Id                   : {<GUID>}
Name                 : Wi-Fi or Ethernet or Wwanpp or Wireless80211
Description          : Intel(R) Dual Band Wireless-AC 8265
NetworkInterfaceType : Wireless80211
OperationalStatus    : Up or Down
Speed                : 866700000
IsReceiveOnly        : False or True
SupportsMulticast    : True or False
IpVersion            : {IPv4, IPv6}
````

# Get-PsNetAdapterConfiguration

Get-PsNetAdapterConfiguration - get the network interface configuration for all adapters.  

````powershell
Get-PsNetAdapterConfiguration | Where-Object Index -eq 11

Succeeded            : True
Index                : 11
Id                   : {<GUID>}
Name                 : Wi-Fi or Ethernet or Wwanpp or Wireless80211
Description          : Intel(R) Dual Band Wireless-AC 8265
NetworkInterfaceType : Wireless80211
OperationalStatus    : Up or Down
Speed                : 866700000
IsReceiveOnly        : False or True
SupportsMulticast    : True or False
IpVersion            : {IPv4, IPv6}
IpV4Addresses        : {<IP Address V4>}
IpV6Addresses        : {<IP Address V6>}
PhysicalAddres       : MAC Address
IsDnsEnabled         : False or True
IsDynamicDnsEnabled  : True or False
DnsSuffix            : <DNS Suffix>
DnsAddresses         : {<IP Address V4>}
Mtu                  : False or True
IsForwardingEnabled  : True or False
IsAPIPAEnabled       : False or True
IsAPIPAActive        : True or False
IsDhcpEnabled        : True or False
DhcpServerAddresses  : {<IP Address V4>}
UsesWins             : False or True
WinsServersAddresses : {<IP Address V4>}
GatewayIpV4Addresses : {<IP Address V4>}
GatewayIpV6Addresses : {<IP Address V6>}
````

# Get-PsNetRoutingTable

Get-PsNetRoutingTable - Get Routing Table
Format the Routing Table to an object.

Get-PsNetRoutingTable -IpVersion IPv4 or IPv6

````powershell
Get-PsNetRoutingTable -IpVersion IPv4 | Format-Table

Succeeded AddressFamily Destination     Netmask         Gateway     Interface     Metric
--------- ------------- -----------     -------         -------     ---------     ------
     True IPv4          0.0.0.0         0.0.0.0         10.29.191.1 10.29.191.zzz 45
     True IPv4          10.29.191.0     255.255.255.0   On-link     10.29.191.zzz 301
     True IPv4          10.29.191.zzz   255.255.255.255 On-link     10.29.191.zzz 301
     True IPv4          10.29.191.zzz   255.255.255.255 On-link     10.29.191.zzz 301
     True IPv4          127.0.0.0       255.0.0.0       On-link     127.0.0.1     331
     True IPv4          127.0.0.1       255.255.255.255 On-link     127.0.0.1     331
     True IPv4          127.255.255.255 255.255.255.255 On-link     127.0.0.1     331
     True IPv4          224.0.0.0       240.0.0.0       On-link     127.0.0.1     331
     True IPv4          224.0.0.0       240.0.0.0       On-link     10.29.191.zzz 301
     True IPv4          255.255.255.255 255.255.255.255 On-link     127.0.0.1     331
     True IPv4          255.255.255.255 255.255.255.255 On-link     10.29.191.zzz 301
````

# Get-PsNetHostsTable

Get-PsNetHostsTable - Get hostsfile
Format the hostsfile to an object.

Get-PsNetHostsTable

````powershell
Get-PsNetHostsTable

Succeeded IpAddress    Compuername FullyQualifiedName
--------- ---------    ----------- ------------------
     True 192.168.1.27 computer1   computername1.fqdn
     True 192.168.1.28 computer2
     True 192.168.1.29 computer3   computername3.fqdn
````

[ [Top] ](#table-of-contents)