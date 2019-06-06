# Generate UML-Diagram

To write automated UML-Diagrams, you need PSClassUtils from Stéphane van Gulick.

## Install Module PSClassUtils

You can install PSClassUtils from the PowerShell Gallery:

````powershell
Install-Module -Name PSClassUtils
Import-Module -Name PSClassUtils
Install-CUDiagramPrerequisites
````

## Write Diagrams

Write a Diagram for a single class:

````powershell
Write-CUClassDiagram -Path D:\03_github.com\PsNetTools\Code\Classes\\02-PsNetDig.ps1 -OutPutType Combined -OutputFormat jpg -ExportFolder D:\03_github.com\PsNetTools\Doc
````

Write a Diagram for all classes in a folder:

````powershell
Write-CUClassDiagram -Path D:\03_github.com\PsNetTools\Code\Classes\ -OutPutType Combined -OutputFormat jpg -ExportFolder D:\03_github.com\PsNetTools\Doc
````
