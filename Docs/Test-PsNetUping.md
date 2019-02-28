---
external help file: PsNetTools-help.xml
Module Name: PsNetTools
online version: https://github.com/tinuwalther/PsNetTools
schema: 2.0.0
---

# Test-PsNetUping

## SYNOPSIS
Test the connectivity over a Udp port

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
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Hashtable
## OUTPUTS

### PSCustomObject
## NOTES
Author: Martin Walther

## RELATED LINKS

[https://github.com/tinuwalther/PsNetTools](https://github.com/tinuwalther/PsNetTools)

