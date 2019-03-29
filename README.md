# Table of Contents

- [Table of Contents](#table-of-contents)
- [PsNetTools](#psnettools)
- [Test-PsNetDig](#test-psnetdig)
- [Test-PsNetPing](#test-psnetping)
- [Test-PsNetTping](#test-psnettping)
- [Test-PsNetTracert](#test-psnettracert)
- [Test-PsNetUping](#test-psnetuping)
- [Test-PsNetWping](#test-psnetwping)
- [Get-PsNetAdapters](#get-psnetadapters)
- [Get-PsNetAdapterConfiguration](#get-psnetadapterconfiguration)
- [Get-PsNetRoutingTable](#get-psnetroutingtable)
- [Get-PsNetHostsTable](#get-psnethoststable)
- [Add-PsNetHostsEntry](#add-psnethostsentry)
- [Remove-PsNetHostsEntry](#remove-psnethostsentry)
- [How to Export settings](#how-to-export-settings)
- [Start-PsNetPortListener](#start-psnetportlistener)

# PsNetTools

PsNetTools is a cross platform PowerShell module to test some network features on Windows and Mac.  

![PsNetTools](./Images/NewPsNetTools.png)

Image generated with [PSWordCloud](https://github.com/vexx32/PSWordCloud) by Joel Sallow.

Import Module:  

````powershell
Import-Module .\PsNetTools.psd1 -Force
````

List all ExportedCommands:  

````powershell
Get-Command -Module PsNetTools

CommandType     Name                                               Version    Source
-----------     ----                                               -------    ------
Function        Add-PsNetHostsEntry                                0.7.0      PsNetTools
Function        Get-PsNetAdapterConfiguration                      0.7.0      PsNetTools
Function        Get-PsNetAdapters                                  0.7.0      PsNetTools
Function        Get-PsNetHostsTable                                0.7.0      PsNetTools
Function        Get-PsNetRoutingTable                              0.7.0      PsNetTools
Function        Remove-PsNetHostsEntry                             0.7.0      PsNetTools
Function        Start-PsNetPortListener                            0.7.0      PsNetTools
Function        Test-PsNetDig                                      0.7.0      PsNetTools
Function        Test-PsNetPing                                     0.7.0      PsNetTools
Function        Test-PsNetTping                                    0.7.0      PsNetTools
Function        Test-PsNetTracert                                  0.7.0      PsNetTools
Function        Test-PsNetUping                                    0.7.0      PsNetTools
Function        Test-PsNetWping                                    0.7.0      PsNetTools
````

# Test-PsNetDig

Resolves a hostname to the IP addresses or an IP Address to the hostname.  

````powershell
Test-PsNetDig [-Destination] <String[]> [<CommonParameters>]
````

**Example 1:**

````powershell
Test-PsNetDig -Destination sbb.ch

Succeeded   : True
InputString : sbb.ch
Destination : sbb.ch
IpV4Address : 194.150.245.142
IpV6Address : 2a00:4bc0:ffff:ffff::c296:f58e
TimeMs      : 3
````

**Example 2:**

````powershell
Test-PsNetDig -Destination sbb.ch,google.com | Format-Table

Succeeded InputString Destination IpV4Address     IpV6Address                    TimeMs
--------- ----------- ----------- -----------     -----------                    ------
     True sbb.ch      sbb.ch      194.150.245.142 2a00:4bc0:ffff:ffff::c296:f58e      4
     True google.com  google.com  172.217.168.14  2a00:1450:400a:802::200e            3
````

**Example 3:**

````powershell
'sbb.ch','google.com' | Test-PsNetDig | Format-Table

Succeeded InputString Destination IpV4Address     IpV6Address                    TimeMs
--------- ----------- ----------- -----------     -----------                    ------
     True sbb.ch      sbb.ch      194.150.245.142 2a00:4bc0:ffff:ffff::c296:f58e      4
     True google.com  google.com  216.58.215.238  2a00:1450:400a:801::200e           26
````

# Test-PsNetPing

Attempts to send an ICMP echo message to a remote computer and receive a corresponding ICMP echo reply message from the remote computer.

````powershell
Test-PsNetPing [-Destination] <String[]> [[-try] <Int32>] [<CommonParameters>]
````

- Destination: Hostname or IP Address or Alias as String or String-Array
- try: Number of attempts to send ICMP echo message

**Example 1:**

````powershell
Test-PsNetPing -Destination sbb.ch

IcmpSucceeded     : True
IPAddress         : 2a00:4bc0:ffff:ffff::c296:f58e
BytesSend         : 32
BytesReceived     : 0
Destination       : sbb.ch
StatusDescription : ICMP Success
MinTimeout        : 0
MaxTimeout        : 1000
TimeMs            : 19
````

**Example 2:**

````powershell
Test-PsNetPing -Destination sbb.ch -try 5

ICMP ping sbb.ch, IPAddress: 2a00:4bc0:ffff:ffff::c296:f58e, time: 19, send: 32, received: 32, ICMP Success
ICMP ping sbb.ch, IPAddress: 2a00:4bc0:ffff:ffff::c296:f58e, time: 19, send: 32, received: 32, ICMP Success
ICMP ping sbb.ch, IPAddress: 2a00:4bc0:ffff:ffff::c296:f58e, time: 19, send: 32, received: 32, ICMP Success
ICMP ping sbb.ch, IPAddress: 2a00:4bc0:ffff:ffff::c296:f58e, time: 19, send: 32, received: 32, ICMP Success
ICMP ping sbb.ch, IPAddress: 2a00:4bc0:ffff:ffff::c296:f58e, time: 19, send: 32, received: 32, ICMP Success
````

**Example 3:**

````powershell
Test-PsNetPing -Destination sbb.ch, microsoft.com, google.com | Format-Table

IcmpSucceeded IPAddress                      BytesSend BytesReceived Destination   StatusDescription MinTimeout MaxTimeout TimeMs
------------- ---------                      --------- ------------- -----------   ----------------- ---------- ---------- ------
         True 2a00:4bc0:ffff:ffff::c296:f58e        32             0 sbb.ch        ICMP Success               0       1000     18
        False 0.0.0.0                               32             0 microsoft.com ICMP TimedOut              0       1000      0
         True 2a00:1450:400a:802::200e              32             0 google.com    ICMP Success               0       1000     18
````

**Example 4:**

````powershell
Test-PsNetPing -Destination sbb.ch, microsoft.com, google.com -try 2

ICMP ping sbb.ch, IPAddress: 2a00:4bc0:ffff:ffff::c296:f58e, time: 18, send: 32, received: 32, ICMP Success
ICMP ping sbb.ch, IPAddress: 2a00:4bc0:ffff:ffff::c296:f58e, time: 20, send: 32, received: 32, ICMP Success
ICMP ping microsoft.com, IPAddress: 0.0.0.0, time: 0, send: 32, received: 0, ICMP TimedOut
ICMP ping microsoft.com, IPAddress: 0.0.0.0, time: 0, send: 32, received: 0, ICMP TimedOut
ICMP ping google.com, IPAddress: 2a00:1450:400a:801::200e, time: 17, send: 32, received: 32, ICMP Success
ICMP ping google.com, IPAddress: 2a00:1450:400a:801::200e, time: 17, send: 32, received: 32, ICMP Success
````

# Test-PsNetTping

Test connectivity to an endpoint over the specified Tcp port.  
It's like the cmdlet Test-NetConnection, but with the ability to specify a timeout in ms.  

````powershell
Test-PsNetTping -Destination <String[]> [-CommonTcpPort] <String> [-MinTimeout <Int32>] [-MaxTimeout <Int32>]
````

````powershell
Test-PsNetTping -Destination <String[]> -TcpPort <Int32[]> [-MinTimeout <Int32>] [-MaxTimeout <Int32>]
````

- Destination: Hostname or IP Address or Alias as String or String-Array
- TcpPort:     Tcp Port to use as Interger or Integer-Array
- MinTimeout:  Timeout in ms (optional, default is 0ms)
- MaxTimeout:  Timeout in ms (optional, default is 1000ms)

**Example 1:**

````powershell
Test-PsNetTping -Destination sbb.ch -TcpPort 443 -MaxTimeout 100

TcpSucceeded      : True
TcpPort           : 443
Destination       : sbb.ch
StatusDescription : TCP Test success
MinTimeout        : 0
MaxTimeout        : 100
TimeMs            : 8
````

**Example 2:**

````powershell
Test-PsNetTping -Destination sbb.ch -CommonTcpPort HTTPS -MaxTimeout 100

TcpSucceeded      : True
TcpPort           : 443
Destination       : sbb.ch
StatusDescription : TCP Test success
MinTimeout        : 0
MaxTimeout        : 100
TimeMs            : 14
````

**Example 3:**

````powershell
Test-PsNetTping -Destination sbb.ch, google.com -TcpPort 443 -MaxTimeout 100 | Format-Table

TcpSucceeded TcpPort Destination StatusDescription MinTimeout MaxTimeout TimeMs
------------ ------- ----------- ----------------- ---------- ---------- ------
        True     443 sbb.ch      TCP Test success           0        100      1
        True     443 google.com  TCP Test success           0        100      1
````

**Example 4:**

````powershell
Test-PsNetTping -Destination sbb.ch, google.com -TcpPort 80, 443 -MaxTimeout 100 | Format-Table

TcpSucceeded TcpPort Destination StatusDescription MinTimeout MaxTimeout TimeMs
------------ ------- ----------- ----------------- ---------- ---------- ------
        True      80 sbb.ch      TCP Test success           0        100      5
        True     443 sbb.ch      TCP Test success           0        100      3
        True      80 google.com  TCP Test success           0        100      9
        True     443 google.com  TCP Test success           0        100      2
````

# Test-PsNetTracert

Test Trace Route to a destination

````powershell
Test-PsNetTracert [-Destination] <String[]> [[-MaxHops] <Int32>] [[-MaxTimeout] <Int32>] [-Show]
````

- Destination: Hostname or IP Address or Alias as String or String-Array
- MaxHops:     Count of gateways or router (optional, default is 30)
- MaxTimeout:  Timeout in ms (optional, default is 1000ms)
- Show:        Switch, show the output as line per router instead as Object
  
**Example 1:**

````powershell
Test-PsNetTracert -Destination 'www.microsoft.com' | Format-Table -AutoSize

Hops Time RTT Send Received Destination       Hostname                                 IPAddress                               Status     Message
---- ---- --- ---- -------- -----------       --------                                 ---------                               ------     -------
   1   24   0   32        0 www.microsoft.com *                                        *                                       TtlExpired Go to next address
   2   33   0   32        0 www.microsoft.com ae60-60.ipc-lss690-m-pe-48.bluewin.ch    2001:4d98:bffd:1e::2                    TtlExpired Go to next address
   3   18   0   32        0 www.microsoft.com ae60-60.ipc-lss690-m-pe-48.bluewin.ch    2001:4d98:bffd:1e::2                    TtlExpired Go to next address
   4   21   0   32        0 www.microsoft.com be11-v6.i68geb-025.bb.ip-plus.bluewin.ch 2001:4d98:bffd:1b::3                    TtlExpired Go to next address
   5   17   0   32        0 www.microsoft.com lss-005-lo0-0.ip6.ip-plus.net            2001:918:100:f::1                       TtlExpired Go to next address
   6   18   0   32        0 www.microsoft.com lss-070-loo6.ip6.ip-plus.net             2001:918:100:2e::1                      TtlExpired Go to next address
   7   18  14   32       32 www.microsoft.com Could not resolve                        2001:918:ffc8:fe87::356e                Success    Trace route completed
````

**Example 2:**

````powershell
Test-PsNetTracert -Destination 'www.google.com' -MaxHops 5 -MaxTimeout 1000 | Format-Table -AutoSize

Hops Time RTT Send Received Destination    Hostname                                 IPAddress                               Status     Message
---- ---- --- ---- -------- -----------    --------                                 ---------                               ------     -------
   1   24   0   32        0 www.google.com *                                        *                                       TtlExpired Go to next address
   2   16   0   32        0 www.google.com ae60-60.ipc-lss690-m-pe-48.bluewin.ch    2001:4d98:bffd:1e::2                    TtlExpired Go to next address
   3   15   0   32        0 www.google.com ae60-60.ipc-lss690-m-pe-48.bluewin.ch    2001:4d98:bffd:1e::2                    TtlExpired Go to next address
   4   34   0   32        0 www.google.com be11-v6.i68geb-025.bb.ip-plus.bluewin.ch 2001:4d98:bffd:1b::3                    TtlExpired Go to next address
   5   19   0   32        0 www.google.com zhb-005-loo646.ip6.ip-plus.net           2001:918:100:646::130                   TtlExpired Go to next address
````

**Example 3:**

````powershell
Test-PsNetTracert -Destination 'www.google.com' -MaxHops 15 -MaxTimeout 1000 -Show

Trace route www.google.com over 15 Hops:

Hops, RTT, Send, Received, Destination, Hostname, IPAddress, Status, Messages
2, 0, 32, 0, www.google.com, ae60-60.ipc-lss690-m-pe-48.bluewin.ch, 2001:4d98:bffd:1e::2, TtlExpired, Go to next address
3, 0, 32, 0, www.google.com, ae60-60.ipc-lss690-m-pe-48.bluewin.ch, 2001:4d98:bffd:1e::2, TtlExpired, Go to next address
4, 0, 32, 0, www.google.com, be11-v6.i68geb-025.bb.ip-plus.bluewin.ch, 2001:4d98:bffd:1b::3, TtlExpired, Go to next address
5, 0, 32, 0, www.google.com, zhb-005-loo646.ip6.ip-plus.net, 2001:918:100:646::130, TtlExpired, Go to next address
6, 0, 32, 0, www.google.com, Could not resolve, 2001:4860:1:1::c5a, TtlExpired, Go to next address
7, 0, 32, 0, www.google.com, Could not resolve, 2001:4860:0:9f::1, TtlExpired, Go to next address
8, 0, 32, 0, www.google.com, Could not resolve, 2001:4860:0:1::156d, TtlExpired, Go to next address
9, 18, 32, 32, www.google.com, zrh04s14-in-x04.1e100.net, 2a00:1450:400a:802::2004, Success, Trace route completed
````

# Test-PsNetUping

Test connectivity to an endpoint over the specified Udp port.  
It's like the cmdlet Test-NetConnection, but with the ability to specify a timeout in ms and query for udp.  

````powershell
Test-PsNetUping -Destination <String[]> -UdpPort <Int32[]> [-MinTimeout <Int32>] [-MaxTimeout <Int32>]
````

- Destination: Hostname or IP Address or Alias as String or String-Array
- UdpPort:     Udp Port to use as Interger or Integer-Array
- MinTimeout:  Timeout in ms (optional, default is 0ms)
- MaxTimeout:  Timeout in ms (optional, default is 1000ms)

**Example 1:**

````powershell
Test-PsNetUping -Destination sbb.ch -UdpPort 53

UdpSucceeded      : False
UdpPort           : 53
Destination       : sbb.ch
StatusDescription : "A connection attempt failed because the connected party did not properly respond after a period
                    of time, or established connection failed because connected host has failed to respond"
MinTimeout        : 0
MaxTimeout        : 1000
TimeMs            : 1000
````

**Example 2:**

````powershell
Test-PsNetUping -Destination sbb.ch,google.com -UdpPort 53 | Format-Table

Succeeded TargetName UdpPort UdpSucceeded Duration MinTimeout MaxTimeout
--------- ---------- ------- ------------ -------- ---------- ----------
     True sbb.ch          53        False 1022ms   0ms        1000ms
     True google.com      53        False 1020ms   0ms        1000ms
````

**Example 3:**

````powershell
Test-PsNetUping -Destination sbb.ch,google.com -UdpPort 53,139 | Format-Table

Succeeded TargetName UdpPort UdpSucceeded Duration MinTimeout MaxTimeout
--------- ---------- ------- ------------ -------- ---------- ----------
     True sbb.ch          53        False 1160ms   0ms        1000ms
     True sbb.ch         139        False 1016ms   0ms        1000ms
     True google.com      53        False 1104ms   0ms        1000ms
     True google.com     139        False 1025ms   0ms        1000ms
````

# Test-PsNetWping

It's like the cmdlet Invoke-WebRequest, but with the ability to specify 'noproxy' with PowerShell 5.1.  

````powershell
Test-PsNetWping [-Destination] <String[]> [[-MinTimeout] <Int32>] [[-MaxTimeout] <Int32>] [-NoProxy]
````

- Destination: WebUri as String or String-Array
- MinTimeout:  Timeout in ms (optional, default is 0ms)
- MaxTimeout:  Timeout in ms (optional, default is 1000ms)
- NoProxy:     Switch (optional)

**Example 1:**

````powershell
Test-PsNetWping -Destination 'https://sbb.ch'

HttpSucceeded     : True
ResponsedUrl      : https://www.sbb.ch/de/
NoProxy           : False
Destination       : https://sbb.ch
StatusDescription : OK
MinTimeout        : 0
MaxTimeout        : 1000
TimeMs            : 331
````

**Example 2:**

````powershell
Test-PsNetWping -Destination https://sbb.ch, google.com | Format-Table

HttpSucceeded ResponsedUrl           NoProxy Destination       StatusDescription MinTimeout MaxTimeout TimeMs
------------- ------------           ------- -----------       ----------------- ---------- ---------- ------
         True https://www.sbb.ch/de/   False https://sbb.ch    OK                         0       1000    150
         True http://www.google.com/   False http://google.com OK                         0       1000    239
````

**Example 3:**

````powershell
Test-PsNetWping -Destination 'https://sbb.ch', 'https://google.com' -MaxTimeout 1000 -NoProxy | Format-Table

HttpSucceeded ResponsedUrl            NoProxy Destination        StatusDescription MinTimeout MaxTimeout TimeMs
------------- ------------            ------- -----------        ----------------- ---------- ---------- ------
         True https://www.sbb.ch/de/     True https://sbb.ch     OK                         0       1000    157
         True https://www.google.com/    True https://google.com OK                         0       1000    307
````

# Get-PsNetAdapters

List all network adapters.

````powershell
Get-PsNetAdapters | Where-Object Index -eq 11

Succeeded            : True
Index                : 25
Name                 : vEthernet (Internale HyperV)
Description          : Hyper-V Virtual Ethernet Adapter
NetworkInterfaceType : Ethernet
OperationalStatus    : Up
PhysicalAddres       : 02:38:7A:1A:03:0E
IpVersion            : IPv4 IPv6
IsAPIPAEnabled       : True
IpV4Addresses        : {169.254.68.121}
IpV6Addresses        : {}
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

# Add-PsNetHostsEntry

**WARNING:** Running this command with elevated privilege.

Add any entries to the hosts-file.

- create a backup for the hostsfile
- if an error occoure, the backup-file will be restored automatically

````powershell
Add-PsNetHostsEntry [[-Path] <String>] [-IPAddress] <String> [-Hostname] <String> [-FullyQualifiedName] <String>
````

- IPAddress:          IP Address to add  
- Hostname:           Hostname to add  
- FullyQualifiedName: FullyQualifiedName to add  

````powershell
Add-PsNetHostsEntry -IPAddress 127.0.0.1 -Hostname tinu -FullyQualifiedName tinu.walther.ch

Succeeded HostsEntry                     BackupPath                   Message
--------- ----------                     ----------                   -------
     True 127.0.0.1 tinu tinu.walther.ch D:\hosts_20190301-185838.txt Entry added
````

# Remove-PsNetHostsEntry

**WARNING:** Running this command with elevated privilege.

Remove an entry from the hosts-file.

- create a backup for the hostsfile
- if an error occoure, the backup-file will be restored automatically

````powershell
Remove-PsNetHostsEntry -Hostsentry '127.0.0.1 tinu'
````

- Hostsentry: IP Address followed by the hostname to remove  

````powershell
Remove-PsNetHostsEntry -Hostsentry '127.0.0.1 tinu'

Succeeded HostsEntry                     BackupPath                   Message
--------- ----------                     ----------                   -------
     True 127.0.0.1 tinu tinu.walther.ch D:\hosts_20190301-190104.txt Entry removed
````

# How to Export settings

You can easy export all the output of the commands as a JSON-file with the following CmdLets:

- ConvertTo-JSON
- Set-Content

As an example run Test-PsNetDig:

````powershell
Test-PsNetDig sbb.ch

Succeeded   : True
InputString : sbb.ch
Destination : sbb.ch
IpV4Address : 194.150.245.142
IpV6Address : 2a00:4bc0:ffff:ffff::c296:f58e
TimeMs      : 47
````

Convert the result from Test-PsNetDig to a JSON-Object:

````powershell
Test-PsNetDig sbb.ch | ConvertTo-Json

{
  "Succeeded": true,
  "InputString": "sbb.ch",
  "Destination": "sbb.ch",
  "IpV4Address": {
    "AddressFamily": 2,
    "ScopeId": null,
    "IsIPv6Multicast": false,
    "IsIPv6LinkLocal": false,
    "IsIPv6SiteLocal": false,
    "IsIPv6Teredo": false,
    "IsIPv4MappedToIPv6": false,
    "Address": 2398459586
  },
  "IpV6Address": {
    "AddressFamily": 23,
    "ScopeId": 0,
    "IsIPv6Multicast": false,
    "IsIPv6LinkLocal": false,
    "IsIPv6SiteLocal": false,
    "IsIPv6Teredo": false,
    "IsIPv4MappedToIPv6": false,
    "Address": null
  },
  "TimeMs": 4
}
````

Export the JSON-Object from Test-PsNetDig to a file:

````powershell
Test-PsNetDig sbb.ch | ConvertTo-Json | Set-Content D:\PsNetDig.json
````

# Start-PsNetPortListener

Temporarily listen on a given TCP port for connections dumps connections to the screen

- TcpPort: The TCP port that the listener should attach to
- MaxTimeout: MaxTimeout in milliseconds to wait, default is 5000

````powershell
Start-PsNetPortListener -TcpPort 443

Listening on TCP port 443, press CTRL+C to cancel

DateTime            AddressFamily Address    Port
--------            ------------- -------    ----
21.02.2019 19:55:39  InterNetwork 127.0.0.1 53613
21.02.2019 19:55:54  InterNetwork 127.0.0.1 53631
21.02.2019 19:56:07  InterNetwork 127.0.0.1 53666
Listener Closed Safely
````

[ [Top] ](#table-of-contents)