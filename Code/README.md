# Table of content

- [Table of content](#table-of-content)
- [Code](#code)
  - [Classes](#classes)
  - [Functions](#functions)
    - [Private](#private)
    - [Public](#public)
- [Tests](#tests)
- [CI](#ci)
  - [Build](#build)

# Code

## Classes

Write one Class-file for each Method, and load it to the memory to debug/test.

````powershell
[PsNetTools]::dig('sbb.ch')
````

## Functions

Write one Function-file for each Function, and load it to the memory to debug/test.

````powershell
Test-PsNetDig -Destination sbb.ch
````

### Private

Private Functions, not exported in the Manifest.

### Public

Public Functions, exported in the Manifest.

# Tests

Write one Pester-Test for each Function.

# CI

Start the Buildscript, if all Tests are passed, add, commit, push and merge it.

## Build

Build.ps1 create a new Module-file (psm1), update the Manifest-file (psd1) and run the Pester Tests.

````text
PS > .\03_Build.ps1
[BUILD] [START] Launching Build Process
[BUILD] [PSM1 ] PSM1 file detected. Deleting...
[BUILD] [Code ] Loading Class, public and private functions
[BUILD] [START] [PSM1] Building Module PSM1
[BUILD] [END  ] [PSM1] building Module PSM1
[BUILD] [START] [PSD1] Manifest PSD1
[BUILD] [PSD1 ] Adding functions to export
[BUILD] [END  ] [PSD1] building Manifest
[TESTS] [START] Launching of Testing Process
Executing all tests in 'D:\PsNetTools\Tests'
[TESTS] [END ] End of Testing Process
[BUILD] [END  ] [OK] All Tests are passed, ready to merge
````

[ [Top] ](#table-of-content)