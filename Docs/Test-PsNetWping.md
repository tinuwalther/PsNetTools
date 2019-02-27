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

