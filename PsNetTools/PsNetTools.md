# PsNetTools

PsNetTools is a cross platform PowerShell module to test some network features on Windows and Mac.


# Table of Contents

- [PsNetTools](#psnettools)
- [Table of Contents](#table-of-contents)
  - [schema: 2.0.0](#schema-200)
- [Add-PsNetHostsEntry](#add-psnethostsentry)
  - [SYNOPSIS](#synopsis)
  - [SYNTAX](#syntax)
  - [DESCRIPTION](#description)
  - [EXAMPLES](#examples)
    - [EXAMPLE 1](#example-1)
  - [PARAMETERS](#parameters)
    - [-Path](#path)
    - [-IPAddress](#ipaddress)
    - [-Hostname](#hostname)
    - [-FullyQualifiedName](#fullyqualifiedname)
    - [CommonParameters](#commonparameters)
  - [INPUTS](#inputs)
    - [Hashtable](#hashtable)
  - [OUTPUTS](#outputs)
    - [PSCustomObject](#pscustomobject)
  - [NOTES](#notes)
  - [RELATED LINKS](#related-links)
  - [schema: 2.0.0](#schema-200-1)
- [Get-PsNetAdapterConfiguration](#get-psnetadapterconfiguration)
  - [SYNOPSIS](#synopsis-1)
  - [SYNTAX](#syntax-1)
  - [DESCRIPTION](#description-1)
  - [EXAMPLES](#examples-1)
    - [EXAMPLE 1](#example-1-1)
  - [PARAMETERS](#parameters-1)
    - [CommonParameters](#commonparameters-1)
  - [INPUTS](#inputs-1)
  - [OUTPUTS](#outputs-1)
    - [PSCustomObject](#pscustomobject-1)
  - [NOTES](#notes-1)
  - [RELATED LINKS](#related-links-1)
  - [schema: 2.0.0](#schema-200-2)
- [Get-PsNetAdapters](#get-psnetadapters)
  - [SYNOPSIS](#synopsis-2)
  - [SYNTAX](#syntax-2)
  - [DESCRIPTION](#description-2)
  - [EXAMPLES](#examples-2)
    - [EXAMPLE 1](#example-1-2)
  - [PARAMETERS](#parameters-2)
    - [CommonParameters](#commonparameters-2)
  - [INPUTS](#inputs-2)
  - [OUTPUTS](#outputs-2)
    - [PSCustomObject](#pscustomobject-2)
  - [NOTES](#notes-2)
  - [RELATED LINKS](#related-links-2)
  - [schema: 2.0.0](#schema-200-3)
- [Get-PsNetHostsTable](#get-psnethoststable)
  - [SYNOPSIS](#synopsis-3)
  - [SYNTAX](#syntax-3)
  - [DESCRIPTION](#description-3)
  - [EXAMPLES](#examples-3)
    - [EXAMPLE 1](#example-1-3)
  - [PARAMETERS](#parameters-3)
    - [-Path](#path-1)
    - [CommonParameters](#commonparameters-3)
  - [INPUTS](#inputs-3)
  - [OUTPUTS](#outputs-3)
    - [PSCustomObject](#pscustomobject-3)
  - [NOTES](#notes-3)
  - [RELATED LINKS](#related-links-3)
  - [schema: 2.0.0](#schema-200-4)
- [Get-PsNetRoutingTable](#get-psnetroutingtable)
  - [SYNOPSIS](#synopsis-4)
  - [SYNTAX](#syntax-4)
  - [DESCRIPTION](#description-4)
  - [EXAMPLES](#examples-4)
    - [EXAMPLE 1](#example-1-4)
    - [EXAMPLE 2](#example-2)
  - [PARAMETERS](#parameters-4)
    - [-IpVersion](#ipversion)
    - [CommonParameters](#commonparameters-4)
  - [INPUTS](#inputs-4)
  - [OUTPUTS](#outputs-4)
    - [PSCustomObject](#pscustomobject-4)
  - [NOTES](#notes-4)
  - [RELATED LINKS](#related-links-4)
  - [schema: 2.0.0](#schema-200-5)
- [Remove-PsNetHostsEntry](#remove-psnethostsentry)
  - [SYNOPSIS](#synopsis-5)
  - [SYNTAX](#syntax-5)
  - [DESCRIPTION](#description-5)
  - [EXAMPLES](#examples-5)
    - [EXAMPLE 1](#example-1-5)
  - [PARAMETERS](#parameters-5)
    - [-Path](#path-2)
    - [-Hostsentry](#hostsentry)
    - [CommonParameters](#commonparameters-5)
  - [INPUTS](#inputs-5)
    - [Hashtable](#hashtable-1)
  - [OUTPUTS](#outputs-5)
    - [PSCustomObject](#pscustomobject-5)
  - [NOTES](#notes-5)
  - [RELATED LINKS](#related-links-5)
  - [schema: 2.0.0](#schema-200-6)
- [Start-PsNetPortListener](#start-psnetportlistener)
  - [SYNOPSIS](#synopsis-6)
  - [SYNTAX](#syntax-6)
  - [DESCRIPTION](#description-6)
  - [EXAMPLES](#examples-6)
    - [EXAMPLE 1](#example-1-6)
  - [PARAMETERS](#parameters-6)
    - [-TcpPort](#tcpport)
    - [-MaxTimeout](#maxtimeout)
    - [CommonParameters](#commonparameters-6)
  - [INPUTS](#inputs-6)
  - [OUTPUTS](#outputs-6)
    - [PSCustomObject](#pscustomobject-6)
  - [NOTES](#notes-6)
  - [RELATED LINKS](#related-links-6)
  - [schema: 2.0.0](#schema-200-7)
- [Test-PsNetDig](#test-psnetdig)
  - [SYNOPSIS](#synopsis-7)
  - [SYNTAX](#syntax-7)
  - [DESCRIPTION](#description-7)
  - [EXAMPLES](#examples-7)
    - [EXAMPLE 1](#example-1-7)
    - [EXAMPLE 2](#example-2-1)
    - [EXAMPLE 3](#example-3)
    - [EXAMPLE 4](#example-4)
  - [PARAMETERS](#parameters-7)
    - [-Destination](#destination)
    - [CommonParameters](#commonparameters-7)
  - [INPUTS](#inputs-7)
    - [Hashtable](#hashtable-2)
  - [OUTPUTS](#outputs-7)
    - [PSCustomObject](#pscustomobject-7)
  - [NOTES](#notes-7)
  - [RELATED LINKS](#related-links-7)
  - [schema: 2.0.0](#schema-200-8)
- [Test-PsNetTping](#test-psnettping)
  - [SYNOPSIS](#synopsis-8)
  - [SYNTAX](#syntax-8)
    - [CommonTCPPort](#commontcpport)
    - [RemotePort](#remoteport)
  - [DESCRIPTION](#description-8)
  - [EXAMPLES](#examples-8)
    - [EXAMPLE 1](#example-1-8)
    - [EXAMPLE 2](#example-2-2)
    - [EXAMPLE 3](#example-3-1)
    - [EXAMPLE 4](#example-4-1)
  - [PARAMETERS](#parameters-8)
    - [-Destination](#destination-1)
    - [-CommonTcpPort](#commontcpport)
    - [-TcpPort](#tcpport-1)
    - [-MinTimeout](#mintimeout)
    - [-MaxTimeout](#maxtimeout-1)
    - [CommonParameters](#commonparameters-8)
  - [INPUTS](#inputs-8)
    - [Hashtable](#hashtable-3)
  - [OUTPUTS](#outputs-8)
    - [PSCustomObject](#pscustomobject-8)
  - [NOTES](#notes-8)
  - [RELATED LINKS](#related-links-8)
  - [schema: 2.0.0](#schema-200-9)
- [Test-PsNetTracert](#test-psnettracert)
  - [SYNOPSIS](#synopsis-9)
  - [SYNTAX](#syntax-9)
  - [DESCRIPTION](#description-9)
  - [EXAMPLES](#examples-9)
    - [EXAMPLE 1](#example-1-9)
    - [EXAMPLE 2](#example-2-3)
    - [EXAMPLE 3](#example-3-2)
  - [PARAMETERS](#parameters-9)
    - [-Destination](#destination-2)
    - [-MaxHops](#maxhops)
    - [-MaxTimeout](#maxtimeout-2)
    - [-Show](#show)
    - [CommonParameters](#commonparameters-9)
  - [INPUTS](#inputs-9)
    - [Hashtable](#hashtable-4)
  - [OUTPUTS](#outputs-9)
    - [PSCustomObject](#pscustomobject-9)
  - [NOTES](#notes-9)
  - [RELATED LINKS](#related-links-9)
  - [schema: 2.0.0](#schema-200-10)
- [Test-PsNetUping](#test-psnetuping)
  - [SYNOPSIS](#synopsis-10)
  - [SYNTAX](#syntax-10)
  - [DESCRIPTION](#description-10)
  - [EXAMPLES](#examples-10)
    - [EXAMPLE 1](#example-1-10)
    - [EXAMPLE 2](#example-2-4)
    - [EXAMPLE 3](#example-3-3)
  - [PARAMETERS](#parameters-10)
    - [-Destination](#destination-3)
    - [-UdpPort](#udpport)
    - [-MinTimeout](#mintimeout-1)
    - [-MaxTimeout](#maxtimeout-3)
    - [CommonParameters](#commonparameters-10)
  - [INPUTS](#inputs-10)
    - [Hashtable](#hashtable-5)
  - [OUTPUTS](#outputs-10)
    - [PSCustomObject](#pscustomobject-10)
  - [NOTES](#notes-10)
  - [RELATED LINKS](#related-links-10)
  - [schema: 2.0.0](#schema-200-11)
- [Test-PsNetWping](#test-psnetwping)
  - [SYNOPSIS](#synopsis-11)
  - [SYNTAX](#syntax-11)
  - [DESCRIPTION](#description-11)
  - [EXAMPLES](#examples-11)
    - [EXAMPLE 1](#example-1-11)
    - [EXAMPLE 2](#example-2-5)
    - [EXAMPLE 3](#example-3-4)
  - [PARAMETERS](#parameters-11)
    - [-Destination](#destination-4)
    - [-MinTimeout](#mintimeout-2)
    - [-MaxTimeout](#maxtimeout-4)
    - [-NoProxy](#noproxy)
    - [CommonParameters](#commonparameters-11)
  - [INPUTS](#inputs-11)
    - [Hashtable](#hashtable-6)
  - [OUTPUTS](#outputs-11)
    - [PSCustomObject](#pscustomobject-11)
  - [NOTES](#notes-11)
  - [RELATED LINKS](#related-links-11)

---
external help file: PsNetTools-help.xml
Module Name: PsNetTools
online version: https://github.com/tinuwalther/PsNetTools
schema: 2.0.0
---

# Add-PsNetHostsEntry

## SYNOPSIS
Add entries to the hosts-file

## SYNTAX

```
Add-PsNetHostsEntry [[-Path] <String>] [-IPAddress] <String> [-Hostname] <String>
 [-FullyQualifiedName] <String> [<CommonParameters>]
```

## DESCRIPTION
Running this command with elevated privilege.
Add any entries to the hosts-file

## EXAMPLES

### EXAMPLE 1
```
Add-PsNetHostsEntry -IPAddress 127.0.0.1 -Hostname tinu -FullyQualifiedName tinu.walther.ch
```

## PARAMETERS

### -Path
Path to the hostsfile, can be empty

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IPAddress
IP Address to add

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Hostname
Hostname to add

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FullyQualifiedName
FullyQualifiedName to add

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Hashtable
## OUTPUTS

### PSCustomObject
## NOTES
Author: Martin Walther

## RELATED LINKS

[https://github.com/tinuwalther/PsNetTools](https://github.com/tinuwalther/PsNetTools)

---
external help file: PsNetTools-help.xml
Module Name: PsNetTools
online version: https://github.com/tinuwalther/PsNetTools
schema: 2.0.0
---

# Get-PsNetAdapterConfiguration

## SYNOPSIS
Get Network Adapter Configuration

## SYNTAX

```
Get-PsNetAdapterConfiguration [<CommonParameters>]
```

## DESCRIPTION
List network adapter configuraion for all adapters

## EXAMPLES

### EXAMPLE 1
```
Get-PsNetAdapterConfiguration
```

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### PSCustomObject
## NOTES
Author: Martin Walther

## RELATED LINKS

[https://github.com/tinuwalther/PsNetTools](https://github.com/tinuwalther/PsNetTools)

---
external help file: PsNetTools-help.xml
Module Name: PsNetTools
online version: https://github.com/tinuwalther/PsNetTools
schema: 2.0.0
---

# Get-PsNetAdapters

## SYNOPSIS
Get Network Adapters

## SYNTAX

```
Get-PsNetAdapters [<CommonParameters>]
```

## DESCRIPTION
List all network adapters

## EXAMPLES

### EXAMPLE 1
```
Get-PsNetAdapters
```

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### PSCustomObject
## NOTES
Author: Martin Walther

## RELATED LINKS

[https://github.com/tinuwalther/PsNetTools](https://github.com/tinuwalther/PsNetTools)

---
external help file: PsNetTools-help.xml
Module Name: PsNetTools
online version: https://github.com/tinuwalther/PsNetTools
schema: 2.0.0
---

# Get-PsNetHostsTable

## SYNOPSIS
Get the content of the hostsfile

## SYNTAX

```
Get-PsNetHostsTable [[-Path] <String>] [<CommonParameters>]
```

## DESCRIPTION
Format the content of the hostsfile to an object

## EXAMPLES

### EXAMPLE 1
```
Get-PsNetHostsTable -Path "$($env:windir)\system32\drivers\etc\hosts"
```

## PARAMETERS

### -Path
Path to the hostsfile, can be empty

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### PSCustomObject
## NOTES
Author: Martin Walther

## RELATED LINKS

[https://github.com/tinuwalther/PsNetTools](https://github.com/tinuwalther/PsNetTools)

---
external help file: PsNetTools-help.xml
Module Name: PsNetTools
online version: https://github.com/tinuwalther/PsNetTools
schema: 2.0.0
---

# Get-PsNetRoutingTable

## SYNOPSIS
Get the Routing Table

## SYNTAX

```
Get-PsNetRoutingTable [-IpVersion] <String> [<CommonParameters>]
```

## DESCRIPTION
Format the Routing Table to an object

## EXAMPLES

### EXAMPLE 1
```
Get-PsNetRoutingTable -IpVersion IPv4
```

### EXAMPLE 2
```
Get-PsNetRoutingTable -IpVersion IPv6
```

## PARAMETERS

### -IpVersion
IPv4 or IPv6

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### PSCustomObject
## NOTES
Author: Martin Walther

## RELATED LINKS

[https://github.com/tinuwalther/PsNetTools](https://github.com/tinuwalther/PsNetTools)

---
external help file: PsNetTools-help.xml
Module Name: PsNetTools
online version: https://github.com/tinuwalther/PsNetTools
schema: 2.0.0
---

# Remove-PsNetHostsEntry

## SYNOPSIS
Remove an entry from the hostsfile

## SYNTAX

```
Remove-PsNetHostsEntry [[-Path] <String>] [-Hostsentry] <String> [<CommonParameters>]
```

## DESCRIPTION
Running this command with elevated privilege. 
 
Backup the hostsfile and remove an entry from the hostsfile

## EXAMPLES

### EXAMPLE 1
```
Remove-PsNetHostsEntry -Hostsentry '127.0.0.1 tinu'
```

## PARAMETERS

### -Path
Path to the hostsfile, can be empty

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Hostsentry
IP Address and hostname to remove

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Hashtable
## OUTPUTS

### PSCustomObject
## NOTES
Author: Martin Walther

## RELATED LINKS

[https://github.com/tinuwalther/PsNetTools](https://github.com/tinuwalther/PsNetTools)

---
external help file: PsNetTools-help.xml
Module Name: PsNetTools
online version: https://github.com/tinuwalther/PsNetTools
schema: 2.0.0
---

# Start-PsNetPortListener

## SYNOPSIS
Start a TCP Portlistener

## SYNTAX

```
Start-PsNetPortListener [-TcpPort] <Int32> [[-MaxTimeout] <Int32>] [<CommonParameters>]
```

## DESCRIPTION
Temporarily listen on a given TCP port for connections dumps connections to the screen

## EXAMPLES

### EXAMPLE 1
```
Start-PsNetPortListener -TcpPort 443, Listening on TCP port 443, press CTRL+C to cancel
```

## PARAMETERS

### -TcpPort
The TCP port that the listener should attach to

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -MaxTimeout
MaxTimeout in milliseconds to wait, default is 5000

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: 5000
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### PSCustomObject
## NOTES
Author: Martin Walther

## RELATED LINKS

[https://github.com/tinuwalther/PsNetTools](https://github.com/tinuwalther/PsNetTools)

---
external help file: PsNetTools-help.xml
Module Name: PsNetTools
online version: https://github.com/tinuwalther/PsNetTools
schema: 2.0.0
---

# Test-PsNetDig

## SYNOPSIS
Domain information groper

## SYNTAX

```
Test-PsNetDig [-Destination] <String[]> [<CommonParameters>]
```

## DESCRIPTION
Resolves a hostname to the IP addresses or an IP Address to the hostname.

## EXAMPLES

### EXAMPLE 1
```
Resolve a hostname to the IP Address
```

Test-PsNetDig -Destination sbb.ch

### EXAMPLE 2
```
Resolve an IP address to the hostname
```

Test-PsNetDig -Destination '127.0.0.1','194.150.245.142'

### EXAMPLE 3
```
Resolve an array of hostnames to the IP Address
```

Test-PsNetDig -Destination sbb.ch, google.com

### EXAMPLE 4
```
Resolve an array of hostnames to the IP Address with ValueFromPipeline
```

sbb.ch, google.com | Test-PsNetDig

## PARAMETERS

### -Destination
Hostname or IP Address or Alias

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Hashtable
## OUTPUTS

### PSCustomObject
## NOTES
Author: Martin Walther

## RELATED LINKS

[https://github.com/tinuwalther/PsNetTools](https://github.com/tinuwalther/PsNetTools)

---
external help file: PsNetTools-help.xml
Module Name: PsNetTools
online version: https://github.com/tinuwalther/PsNetTools
schema: 2.0.0
---

# Test-PsNetTping

## SYNOPSIS
Test the connectivity over a Tcp port

## SYNTAX

### CommonTCPPort
```
Test-PsNetTping -Destination <String[]> [-CommonTcpPort] <String> [-MinTimeout <Int32>] [-MaxTimeout <Int32>]
 [<CommonParameters>]
```

### RemotePort
```
Test-PsNetTping -Destination <String[]> -TcpPort <Int32[]> [-MinTimeout <Int32>] [-MaxTimeout <Int32>]
 [<CommonParameters>]
```

## DESCRIPTION
Test connectivity to an endpoint over the specified Tcp port

## EXAMPLES

### EXAMPLE 1
```
Test the connectivity to one Destination and one Tcp Port with a max. timeout of 100ms
```

Test-PsNetTping -Destination sbb.ch -TcpPort 443 -MaxTimeout 100

### EXAMPLE 2
```
Test the connectivity to one Destination and one CommonTcpPort with a max. timeout of 100ms
```

Test-PsNetTping -Destination sbb.ch -CommonTcpPort HTTPS -MaxTimeout 100

### EXAMPLE 3
```
Test the connectivity to two Destinations and one Tcp Port with a max. timeout of 100ms
```

Test-PsNetTping -Destination sbb.ch, google.com -TcpPort 443 -MaxTimeout 100

### EXAMPLE 4
```
Test the connectivity to two Destinations and two Tcp Ports with a max. timeout of 100ms
```

Test-PsNetTping -Destination sbb.ch, google.com -TcpPort 80, 443 -MaxTimeout 100 | Format-Table

## PARAMETERS

### -Destination
A String or an Array of Strings with Names or IP Addresses to test \<string\>

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CommonTcpPort
One of the Tcp ports for SMB, HTTP, HTTPS, WINRM, WINRMS, LDAP, LDAPS

```yaml
Type: String
Parameter Sets: CommonTCPPort
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TcpPort
An Integer or an Array of Integers with Tcp Ports to test \<int\>

```yaml
Type: Int32[]
Parameter Sets: RemotePort
Aliases: RemotePort

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MinTimeout
Min.
Timeout in ms, default is 0

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -MaxTimeout
Max.
Timeout in ms, default is 1000

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 1000
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Hashtable
## OUTPUTS

### PSCustomObject
## NOTES
Author: Martin Walther

## RELATED LINKS

[https://github.com/tinuwalther/PsNetTools](https://github.com/tinuwalther/PsNetTools)

---
external help file: PsNetTools-help.xml
Module Name: PsNetTools
online version: https://github.com/tinuwalther/PsNetTools
schema: 2.0.0
---

# Test-PsNetTracert

## SYNOPSIS
Test Trace Route

## SYNTAX

```
Test-PsNetTracert [-Destination] <String[]> [[-MaxHops] <Int32>] [[-MaxTimeout] <Int32>] [-Show]
 [<CommonParameters>]
```

## DESCRIPTION
Test Trace Route to a destination

## EXAMPLES

### EXAMPLE 1
```
Test-PsNetTracert -Destination 'www.sbb.ch'
```

### EXAMPLE 2
```
Test-PsNetTracert -Destination 'www.google.com' -MaxHops 15 -MaxTimeout 1000 | Format-Table -AutoSize
```

### EXAMPLE 3
```
Test-PsNetTracert -Destination 'www.google.com' -MaxHops 15 -MaxTimeout 1000 -Show
```

## PARAMETERS

### -Destination
A String or an Array of Strings with Url's to test

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MaxHops
Max gateways, routers to test, default is 30

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: 30
Accept pipeline input: False
Accept wildcard characters: False
```

### -MaxTimeout
Max.
Timeout in ms, default is 1000

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: 1000
Accept pipeline input: False
Accept wildcard characters: False
```

### -Show
Show the output for each item online

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Hashtable
## OUTPUTS

### PSCustomObject
## NOTES
Author: Martin Walther

## RELATED LINKS

[https://github.com/tinuwalther/PsNetTools](https://github.com/tinuwalther/PsNetTools)

---
external help file: PsNetTools-help.xml
Module Name: PsNetTools
online version: https://github.com/tinuwalther/PsNetTools
schema: 2.0.0
---

# Test-PsNetUping

## SYNOPSIS
Test the connectivity over an Udp port

## SYNTAX

```
Test-PsNetUping -Destination <String[]> -UdpPort <Int32[]> [-MinTimeout <Int32>] [-MaxTimeout <Int32>]
 [<CommonParameters>]
```

## DESCRIPTION
Test connectivity to an endpoint over the specified Udp port

## EXAMPLES

### EXAMPLE 1
```
Test-PsNetUping -Destination sbb.ch, google.com -UdpPort 53, 139 -MaxTimeout 100
```

### EXAMPLE 2
```
Test the connectivity to one Destination and one Udp Port with a max. timeout of 100ms
```

Test-PsNetUping -Destination sbb.ch -UdpPort 53 -MaxTimeout 100

### EXAMPLE 3
```
Test the connectivity to two Destinations and one Udp Port with a max. timeout of 100ms
```

Test-PsNetUping -Destination sbb.ch, google.com -UdpPort 53 -MaxTimeout 100

EXAMPLE
Test the connectivity to two Destinations and two Udp Ports with a max.
timeout of 100ms
Test-PsNetUping -Destination sbb.ch, google.com -UdpPort 53, 139 -MaxTimeout 100 | Format-Table

## PARAMETERS

### -Destination
A String or an Array of Strings with Names or IP Addresses to test \<string\>

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -UdpPort
An Integer or an Array of Integers with Udp Ports to test \<int\>

```yaml
Type: Int32[]
Parameter Sets: (All)
Aliases: RemotePort

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MinTimeout
Min.
Timeout in ms, default is 0

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -MaxTimeout
Max.
Timeout in ms, default is 1000

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 1000
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Hashtable
## OUTPUTS

### PSCustomObject
## NOTES
Author: Martin Walther

## RELATED LINKS

[https://github.com/tinuwalther/PsNetTools](https://github.com/tinuwalther/PsNetTools)

---
external help file: PsNetTools-help.xml
Module Name: PsNetTools
online version: https://github.com/tinuwalther/PsNetTools
schema: 2.0.0
---

# Test-PsNetWping

## SYNOPSIS
Test-PsNetWping

## SYNTAX

```
Test-PsNetWping [-Destination] <String[]> [[-MinTimeout] <Int32>] [[-MaxTimeout] <Int32>] [-NoProxy]
 [<CommonParameters>]
```

## DESCRIPTION
Test web request to an Url

## EXAMPLES

### EXAMPLE 1
```
Test-PsNetWping -Destination 'https://sbb.ch'
```

### EXAMPLE 2
```
Test-PsNetWping -Destination 'https://sbb.ch', 'https://google.com' -MaxTimeout 1000
```

### EXAMPLE 3
```
Test-PsNetWping -Destination 'https://sbb.ch', 'https://google.com' -MaxTimeout 1000 -NoProxy | Format-Table
```

## PARAMETERS

### -Destination
A String or an Array of Strings with Url's to test

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MinTimeout
Min.
Timeout in ms, default is 0

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -MaxTimeout
Max.
Timeout in ms, default is 1000

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: 1000
Accept pipeline input: False
Accept wildcard characters: False
```

### -NoProxy
Test web request without a proxy

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Hashtable
## OUTPUTS

### PSCustomObject
## NOTES
Author: Martin Walther

## RELATED LINKS

[https://github.com/tinuwalther/PsNetTools](https://github.com/tinuwalther/PsNetTools)


[ [Top] ](#psnettools)
