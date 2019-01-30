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
