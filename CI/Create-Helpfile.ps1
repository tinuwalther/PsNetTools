# PlatyPS Markwdon help https://github.com/PowerShell/platyPS

function Set-HeaderLines{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [Object]$Path
    )

$mdcontent = @"
# PsNetTools`n
PsNetTools is a cross platform PowerShell module to test some network features on Windows and Mac.`n

# Table of Contents`n
- [PsNetTools](#psnettools) 

"@
$mdcontent | Out-File -FilePath $Path
}

# Retrieve parent folder
$Current = (Split-Path -Path $MyInvocation.MyCommand.Path)
$Root = ((Get-Item $Current).Parent).FullName
$ModuleName = "PsNetTools"
$ModuleFolderPath = Join-Path -Path $Root -ChildPath $ModuleName
$DocsSourcePath   = Join-Path -Path $Root -ChildPath "Docs"

Write-Host "[BUILD] [START] [MD] $ModuleName Helpfile" -ForegroundColor Yellow
if(-not(Get-Module -ListAvailable platyPS)){
    Install-Module -Name platyPS -Scope CurrentUser
}
if(!(Get-Module platyPS)){
    Import-Module -Name platyPS
}
Import-Module $ModuleFolderPath -Force
if(Get-MarkdownMetadata -Path $DocsSourcePath){
    Write-Host "[BUILD] [UPDATE] [MD] $ModuleName Helpfile" -ForegroundColor Yellow
    Update-MarkdownHelp $DocsSourcePath -Force
}
else{
    Write-Host "[BUILD] [CREATE] [MD] $ModuleName Helpfile" -ForegroundColor Yellow
    New-MarkdownHelp -Module $ModuleName -OutputFolder $DocsSourcePath -Force
}
New-ExternalHelp $DocsSourcePath -OutputPath "$($root)/PsNetTools-help.xml" -Force
Write-Host "[BUILD] [END  ] [MD] $ModuleName Helpfile" -ForegroundColor Yellow

Set-HeaderLines -Path "$($ModuleFolderPath)\$($ModuleName).md"
Get-ChildItem $DocsSourcePath | ForEach-Object {
    #"- [$($_.BaseName)](./Docs/$($_.Name))" | Out-File -FilePath "$($Root)\$($ModuleName).md" -Append
    Get-Content -Path $_.FullName -Filter '*.md' -Exclude 'README.md' | Out-File -FilePath "$($ModuleFolderPath)\$($ModuleName).md" -Append
}

"`n[ [Top] ](#psnettools)" | Out-File -FilePath "$($ModuleFolderPath)\$($ModuleName).md" -Append