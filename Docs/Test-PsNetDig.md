---
external help file: PsNetTools-help.xml
Module Name: PsNetTools
online version:
schema: 2.0.0
---

# Test-PsNetDig

## SYNOPSIS
Test-PsNetDig

## SYNTAX

```
Test-PsNetDig [-Destination] <String[]> [<CommonParameters>]
```

## DESCRIPTION
Resolves a hostname or an ip address

## EXAMPLES

### EXAMPLE 1
```
Test-PsNetDig -Destination sbb.ch, google.com
```

### EXAMPLE 2
```
sbb.ch, google.com | Test-PsNetDig
```

## PARAMETERS

### -Destination
A String or an Array of Strings with Names or IP Addresses to resolve

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

## OUTPUTS

## NOTES
Author: Martin Walther

## RELATED LINKS
