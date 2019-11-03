# From Stephane van Gulick (Thanks!)
# https://github.com/PowerShell/platyPS

Write-Host "[BUILD] [START] Launching Build Process" -ForegroundColor Yellow	

if(Get-Module PsNetTools){
    Remove-Module PsNetTools
}

# Retrieve parent folder
$Current          = (Split-Path -Path $MyInvocation.MyCommand.Path)
$Root             = ((Get-Item $Current).Parent).FullName
$ModuleName       = "PsNetTools"
$ModuleFolderPath = Join-Path -Path $Root -ChildPath $ModuleName
$CodeSourcePath   = Join-Path -Path $Root -ChildPath "Code"
$TestsSourcePath  = Join-Path -Path $Root -ChildPath "Tests"

$ExportPath = Join-Path -Path $ModuleFolderPath -ChildPath "$($ModuleName).psm1"
if(Test-Path $ExportPath){
    Write-Host "[BUILD] [PSM1 ] PSM1 file detected. Deleting..." -ForegroundColor Yellow
    Remove-Item -Path $ExportPath -Force
}
$Date = Get-Date
"<#" | out-File -FilePath $ExportPath -Encoding utf8 -Append
"    Generated at $($Date) by Martin Walther" | out-File -FilePath $ExportPath -Encoding utf8 -Append
"    using module ..\$($ModuleName)\$($ModuleName).psm1" | out-File -FilePath $ExportPath -Encoding utf8 -Append
"#>" | out-File -FilePath $ExportPath -Encoding utf8 -Append

Write-Host "[BUILD] [Code ] Loading Class, public and private functions" -ForegroundColor Yellow

$PublicClasses    = Get-ChildItem -Path "$CodeSourcePath\Classes\" -Filter *.ps1 | sort-object Name
$PrivateFunctions = Get-ChildItem -Path "$CodeSourcePath\Functions\Private" -Filter *.ps1
$PublicFunctions  = Get-ChildItem -Path "$CodeSourcePath\Functions\Public" -Filter *.ps1

$MainPSM1Contents = @()
$MainPSM1Contents += $PublicClasses
$MainPSM1Contents += $PrivateFunctions
$MainPSM1Contents += $PublicFunctions

#Creating PSM1
Write-Host "[BUILD] [START] [PSM1] Building Module PSM1" -ForegroundColor Yellow
"#region namespace $($ModuleName)" | out-File -FilePath $ExportPath -Encoding utf8 -Append
Foreach($file in $MainPSM1Contents){
    Get-Content $File.FullName | out-File -FilePath $ExportPath -Encoding utf8 -Append
}
"#endregion" | out-File -FilePath $ExportPath -Encoding utf8 -Append

Write-Host "[BUILD] [END  ] [PSM1] building Module PSM1 " -ForegroundColor Yellow

Write-Host "[BUILD] [START] [PSD1] Manifest PSD1" -ForegroundColor Yellow
Write-Host "[BUILD] [PSD1 ] Adding functions to export" -ForegroundColor Yellow
$FunctionsToExport = $PublicFunctions.BaseName
$Manifest = Join-Path -Path $ModuleFolderPath -ChildPath "$($ModuleName).psd1"
Update-ModuleManifest -Path $Manifest -FunctionsToExport $FunctionsToExport


$TestsContent = @'
$TestsPath  = Split-Path $MyInvocation.MyCommand.Path
$RootFolder = (get-item $TestsPath).Parent

Push-Location -Path $RootFolder.FullName
Set-Location  -Path $RootFolder.FullName

Import-Module .\PsNetTools -Force
if(!(Get-Module Pester)){
    Import-Module -Name Pester
}

if($PSVersionTable.PSVersion.Major -lt 6){
    $CurrentOS = 'Win'
}
else{
    if($IsMacOS){$CurrentOS = 'Mac'}
    if($IsLinux){$CurrentOS = 'Lnx'}
    if($IsWindows){$CurrentOS = 'Win'}
}

Describe "Testing %FUNCTION% on $($CurrentOS) OS" {
    
    it "[POS] [$($CurrentOS)] Testing %FUNCTION%"{
        {%FUNCTION%} | Should Not Throw
        (%FUNCTION%).Succeeded | should BeTrue
    }

}

Pop-Location
'@

Write-Host "[BUILD] [START] [Tests] Pester Tests" -ForegroundColor Yellow
$FunctionsToExport | ForEach-Object {
    $TestsFile = "$($TestsSourcePath)\$($_).Tests.ps1"
    if(-not(Test-Path $TestsFile)){
        New-Item -Path $TestsFile -ItemType File
        $TestsContent -replace '%FUNCTION%', $_ | out-File -FilePath $TestsFile -Encoding utf8 -Append
    }
}
Write-Host "[BUILD] [END  ] [Tests] Pester Tests" -ForegroundColor Yellow

Describe 'General module control' -Tags 'FunctionalQuality'   {

    It "Import $ModuleName without errors" {
        { Import-Module -Name $ModuleFolderPath -Force -ErrorAction Stop } | Should Not Throw
        Get-Module $ModuleName | Should Not BeNullOrEmpty
    }

    It "Get-Command $ModuleName without errors" {
        { Get-Command -Module $ModuleName -ErrorAction Stop } | Should Not Throw
        Get-Command -Module $ModuleName | Should Not BeNullOrEmpty
    }

    It "Removes $ModuleName without error" {
        { Remove-Module -Name $ModuleName -ErrorAction Stop} | Should not Throw
        Get-Module $ModuleName | Should beNullOrEmpty
    }

}

Write-Host "[BUILD] [END  ] [PSD1] building Manifest" -ForegroundColor Yellow

<#
Write-Host "[BUILD] [START] [MD] $ModuleName Helpfile" -ForegroundColor Yellow
if(!(Get-Module platyPS)){
    Import-Module -Name platyPS
}
Import-Module $Manifest -Force
if(Test-Path $DocsSourcePath){
    Write-Host "[BUILD] [UPDATE] [MD] $ModuleName Helpfile" -ForegroundColor Yellow
    $null = Update-MarkdownHelp $DocsSourcePath -Force
}
else{
    Write-Host "[BUILD] [CREATE] [MD] $ModuleName Helpfile" -ForegroundColor Yellow
    $null = New-MarkdownHelp -Module $ModuleName -OutputFolder $DocsSourcePath -Force
}
Write-Host "[BUILD] [END  ] [MD] $ModuleName Helpfile" -ForegroundColor Yellow
#>
