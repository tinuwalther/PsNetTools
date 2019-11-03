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

