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

