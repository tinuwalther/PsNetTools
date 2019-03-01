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

