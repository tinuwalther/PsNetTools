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

