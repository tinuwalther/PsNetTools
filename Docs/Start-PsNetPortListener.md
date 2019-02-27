---
external help file: PsNetTools-help.xml
Module Name: PsNetTools
online version: https://github.com/tinuwalther/PsNetTools
schema: 2.0.0
---

# Start-PsNetPortListener

## SYNOPSIS
Start a TCP Portlistener

## SYNTAX

```
Start-PsNetPortListener [-TcpPort] <Int32> [[-MaxTimeout] <Int32>] [<CommonParameters>]
```

## DESCRIPTION
Temporarily listen on a given TCP port for connections dumps connections to the screen

## EXAMPLES

### EXAMPLE 1
```
Start-PsNetPortListener -TcpPort 443, Listening on TCP port 443, press CTRL+C to cancel
```

## PARAMETERS

### -TcpPort
The TCP port that the listener should attach to

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -MaxTimeout
MaxTimeout in milliseconds to wait, default is 5000

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: 5000
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

