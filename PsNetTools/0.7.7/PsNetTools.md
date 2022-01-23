# PsNetTools

PsNetTools is a cross platform PowerShell module to test some network features on Windows and Mac.


# Table of Contents

- [PsNetTools](#psnettools) 

---
external help file: PsNetTools-help.xml
Module Name: PsNetTools
online version: https://github.com/tinuwalther/PsNetTools
schema: 2.0.0
---

# Add-PsNetDnsSearchSuffix

## SYNOPSIS
Add-PsNetDnsSearchSuffix

## SYNTAX

```
Add-PsNetDnsSearchSuffix [-NewDNSSearchSuffix] <String[]> [<CommonParameters>]
```

## DESCRIPTION
Running this command with elevated privilege.
Adding any entries to the DnsSearchSuffixList

## EXAMPLES

### EXAMPLE 1
```
Add-PsNetDnsSearchSuffix -DNSSearchSuffix 'test.local'
```

## PARAMETERS

### -NewDNSSearchSuffix
DNSSearchSuffix to add

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### String Array
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
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

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

# Clear-PsNetDnsSearchSuffix

## SYNOPSIS
Clear-PsNetDnsSearchSuffix

## SYNTAX

```
Clear-PsNetDnsSearchSuffix [<CommonParameters>]
```

## DESCRIPTION
Running this command with elevated privilege.
Remove all entries from the DnsSearchSuffixList

## EXAMPLES

### EXAMPLE 1
```
Clear-PsNetDnsSearchSuffix
```

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

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
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

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
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

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

# Get-PsNetDnsSearchSuffix

## SYNOPSIS
Get-PsNetDnsSearchSuffix

## SYNTAX

```
Get-PsNetDnsSearchSuffix [<CommonParameters>]
```

## DESCRIPTION
Running this command with elevated privilege.
Get all entries from the DnsSearchSuffixList

## EXAMPLES

### EXAMPLE 1
```
Get-PsNetDnsSearchSuffix
```

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

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
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

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
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

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

# Remove-PsNetDnsSearchSuffix

## SYNOPSIS
Remove-PsNetDnsSearchSuffix

## SYNTAX

```
Remove-PsNetDnsSearchSuffix [-DNSSearchSuffix] <String[]> [<CommonParameters>]
```

## DESCRIPTION
Running this command with elevated privilege.
Remove any entries from the DnsSearchSuffixList

## EXAMPLES

### EXAMPLE 1
```
Remove-PsNetDnsSearchSuffix -DNSSearchSuffix 'test.local'
```

## PARAMETERS

### -DNSSearchSuffix
DNSSearchSuffix to remove

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### String Array
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
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

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
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

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
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

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

# Test-PsNetPing

## SYNOPSIS
Test ICMP echo

## SYNTAX

```
Test-PsNetPing [-Destination] <String[]> [[-try] <Int32>] [<CommonParameters>]
```

## DESCRIPTION
Attempts to send an ICMP echo message to a remote computer and receive a corresponding ICMP echo reply message from the remote computer.

## EXAMPLES

### EXAMPLE 1
```
Test-PsNetPing -Destination sbb.ch
```

### EXAMPLE 2
```
Test-PsNetPing -Destination sbb.ch -try 5
```

### EXAMPLE 3
```
Test-PsNetPing -Destination sbb.ch, microsoft.com, google.com
```

### EXAMPLE 4
```
Test-PsNetPing -Destination sbb.ch, microsoft.com, google.com -try 3
```

## PARAMETERS

### -Destination
A String or an Array of Strings with Names or IP Addresses to test \<string\>

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

### -try
Number of attempts to send ICMP echo message

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Hashtable
## OUTPUTS

### String
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
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

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
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

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
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

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
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Hashtable
## OUTPUTS

### PSCustomObject
## NOTES
Author: Martin Walther

## RELATED LINKS

[https://github.com/tinuwalther/PsNetTools](https://github.com/tinuwalther/PsNetTools)


[ [Top] ](#psnettools)
