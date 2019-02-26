---
external help file: PsNetTools-help.xml
Module Name: PsNetTools
online version: https://tinuwalther.github.io/
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
Resolve an array of hostnames to the IP Address
```

Test-PsNetDig -Destination sbb.ch, google.com

### EXAMPLE 3
```
Resolve an array of hostnames to the IP Address with ValueFromPipeline
```

sbb.ch, google.com | Test-PsNetDig

## PARAMETERS

### -Destination
Hostname or IP Address or Alias or WebUrl as String or String-Array

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
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Hashtable
## OUTPUTS

### PSCustomObject
### TargetName  : sbb.ch
### IpV4Address : 194.150.245.142
### IpV6Address : 2a00:4bc0:ffff:ffff::c296:f58e
### Duration    : 4ms
## NOTES
Author: Martin Walther

## RELATED LINKS

[https://tinuwalther.github.io/](https://tinuwalther.github.io/)
