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
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Hashtable
## OUTPUTS

### PSCustomObject
## NOTES
Author: Martin Walther

## RELATED LINKS

[https://github.com/tinuwalther/PsNetTools](https://github.com/tinuwalther/PsNetTools)

