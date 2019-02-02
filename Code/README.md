# Table of content

- [Table of content](#table-of-content)
- [Code](#code)
  - [Classes](#classes)
  - [Functions](#functions)
    - [Private](#private)
    - [Public](#public)
- [CI](#ci)
  - [Build](#build)

# Code

## Classes

Write Class-files, and load it to the memory to debug/test.

````powershell
[PsNetTools]::dig('sbb.ch')
````

## Functions

Write Function-files, and load it to the memory to debug/test.

````powershell
Test-PsNetDig -Destination sbb.ch
````

### Private

Private Functions, not exported in the Manifest.

### Public

Public Functions, exported in the Manifest.

# CI

## Build

Build.ps1 create a new Module-file (psm1), update the Manifest-file (psd1) and run the Pester Tests.

````text
[BUILD][START] Launching Build Process
[BUILD][PSM1] PSM1 file detected. Deleting...
[BUILD][Code] Loading Class, public and private functions
[BUILD][START][PSM1] Building Module PSM1
[BUILD][END][PSM1] building Module PSM1
[BUILD][START][PSD1] Manifest PSD1
[BUILD][PSD1] Adding functions to export
[BUILD][END][PSD1] building Manifest
[BUILD][END] End of Build Process
[TESTS][START] Launching of Testing Process
[TESTS][END]   End of Testing Process
[BUILD][END]   End of Build Process
````

[ [Top] ](#table-of-content)