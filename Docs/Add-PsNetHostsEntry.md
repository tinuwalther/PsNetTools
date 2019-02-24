---
external help file: PsNetTools-help.xml
Module Name: PsNetTools
online version:
schema: 2.0.0
---

# Add-PsNetHostsEntry

## SYNOPSIS
Add-PsNetHostsEntry

## SYNTAX

```
Add-PsNetHostsEntry [[-Path] <String>] [-IPAddress] <String> [-Hostname] <String>
 [-FullyQualifiedName] <String> [<CommonParameters>]
```

## DESCRIPTION
Add an entry in the hosts-file

## EXAMPLES

### EXAMPLE 1
```
Add-PsNetHostsEntry -IPAddress 127.0.0.1 -Hostname tinu -FullyQualifiedName tinu.walther.ch
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

### -IPAddress
IP Address to add

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

### -Hostname
Hostname to add

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FullyQualifiedName
FullyQualifiedName to add

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 4
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
