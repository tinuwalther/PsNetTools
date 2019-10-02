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

