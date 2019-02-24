---
external help file: PsNetTools-help.xml
Module Name: PsNetTools
online version:
schema: 2.0.0
---

# Remove-PsNetHostsEntry

## SYNOPSIS
Remove-PsNetHostsEntry

## SYNTAX

```
Remove-PsNetHostsEntry [[-Path] <String>] [-Hostsentry] <String> [<CommonParameters>]
```

## DESCRIPTION
Remove an entry in the hosts-file

## EXAMPLES

### EXAMPLE 1
```
Remove-PsNetHostsEntry -Hostsentry '127.0.0.1 tinu'
```

## PARAMETERS

### -Path
Path to the hostsfile, can be empty

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Hostsentry
IP Address to remove

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Author: Martin Walther

## RELATED LINKS
