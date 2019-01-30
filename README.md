# Table of Contents

- [Table of Contents](#table-of-contents)
- [PsNetTools](#psnettools)
  - [Usage](#usage)
- [Test-PsNetDig](#test-psnetdig)
  - [Get-Help Test-PsNetDig](#get-help-test-psnetdig)
  - [Example Test-PsNetDig](#example-test-psnetdig)
- [Test-PsNetTping](#test-psnettping)
  - [Get-Help Test-PsNetTping](#get-help-test-psnettping)
  - [Example Test-PsNetTping](#example-test-psnettping)
- [Test-PsNetUping](#test-psnetuping)
  - [Get-Help Test-PsNetUping](#get-help-test-psnetuping)
  - [Example Test-PsNetUping](#example-test-psnetuping)
- [Test-PsNetWping](#test-psnetwping)
  - [Get-Help Test-PsNetWping](#get-help-test-psnetwping)
  - [Example Test-PsNetWping](#example-test-psnetwping)
- [Get-PsNetAdapters](#get-psnetadapters)
  - [Get-Help Get-PsNetAdapters](#get-help-get-psnetadapters)
  - [Example Get-PsNetAdapterConfiguration](#example-get-psnetadapterconfiguration)
- [Get-PsNetAdapterConfiguration](#get-psnetadapterconfiguration)
  - [Get-Help Get-PsNetAdapterConfiguration](#get-help-get-psnetadapterconfiguration)
  - [Example Get-PsNetAdapterConfiguration](#example-get-psnetadapterconfiguration-1)

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

ModuleType Version Name       ExportedCommands
---------- ------- ----       ----------------
Script     0.1.2   PsNetTools {PsNetDig, PsNetTping, PsNetUping, PsNetWping}
````

# Test-PsNetDig

Test-PsNetDig - domain information groper.  
Resolves a hostname to the IP addresses or an IP Address to the hostname.  

## Get-Help Test-PsNetDig

Test-PsNetDig -Destination

- Destination: Hostname or IP Address or Alias or WebUrl

## Example Test-PsNetDig

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

## Get-Help Test-PsNetTping

Test-PsNetTping -Destination -TcpPort -Timeout

- Destination: Hostname or IP Address or Alias or WebUrl
- TcpPort:     Tcp Port to use
- Timeout:     Timeout in ms

## Example Test-PsNetTping

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

## Get-Help Test-PsNetUping

Test-PsNetTping -Destination -UdpPort -Timeout

- Destination: Hostname or IP Address or Alias or WebUrl
- UdpPort:     Udp Port to use
- Timeout:     Timeout in ms

## Example Test-PsNetUping

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

## Get-Help Test-PsNetWping

Test-PsNetWping -Destination -Timeout [-NoProxy]

- Destination: WebUri
- Timeout:     Timeout in ms
- NoProxy:     Switch

## Example Test-PsNetWping

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

## Get-Help Get-PsNetAdapters

Get-PsNetAdapters

## Example Get-PsNetAdapterConfiguration

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

## Get-Help Get-PsNetAdapterConfiguration

Get-PsNetAdapterConfiguration

## Example Get-PsNetAdapterConfiguration

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
