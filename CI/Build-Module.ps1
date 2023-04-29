# From Stephane van Gulick (Thanks!)
# https://github.com/PowerShell/platyPS

Write-Host "[$(Get-Date -f 'yyyy-MM-dd HH:mm:ss')] [BUILD] [START] Launching Build Process" -ForegroundColor Cyan	

#region remove module
if(Get-Module PsNetTools){
    Remove-Module PsNetTools
}
#endregion

#region folder and path
$Current          = (Split-Path -Path $MyInvocation.MyCommand.Path)
$Root             = ((Get-Item $Current).Parent).FullName
$ModuleName       = "PsNetTools"
$prompt           = (Read-Host "Enter the Version number of this module in the Semantic Versioning notation [1.0.0]")
if (!$prompt -eq "") {
    $Version = $prompt
}

$ModuleFolderRootPath = Join-Path -Path $Root -ChildPath $ModuleName
$ModuleFolderPath     = Join-Path -Path $ModuleFolderRootPath -ChildPath $Version
$Manifest             = Join-Path -Path $ModuleFolderPath -ChildPath "$($ModuleName).psd1"

$CodeSourcePath   = Join-Path -Path $Root -ChildPath "Code"
$TestsSourcePath  = Join-Path -Path $Root -ChildPath "Tests"

$ExportPath       = Join-Path -Path $ModuleFolderPath -ChildPath "$($ModuleName).psm1"
$PublicClasses    = Get-ChildItem -Path "$CodeSourcePath\Classes\" -Filter *.ps1 | sort-object Name
$PrivateFunctions = Get-ChildItem -Path "$CodeSourcePath\Functions\Private" -Filter *.ps1
$PublicFunctions  = Get-ChildItem -Path "$CodeSourcePath\Functions\Public" -Filter *.ps1

$MainPSM1Contents = @()
$MainPSM1Contents += $PublicClasses
$MainPSM1Contents += $PrivateFunctions
$MainPSM1Contents += $PublicFunctions
#endregion

#region PSM1
if(Test-Path $ExportPath){
    Write-Host "[$(Get-Date -f 'yyyy-MM-dd HH:mm:ss')] [BUILD] [PSM1 ] PSM1 file detected. Deleting..." -ForegroundColor Yellow
    Remove-Item -Path $ExportPath -Force
}

$Content = @"
<#
    Generated at $(Get-Date -f 'yyyy-MM-dd HH:mm:ss') by Martin Walther
    using module ..\$($ModuleName)\$($ModuleName).psm1
#>
"@
$Content | Out-File -FilePath $ExportPath -Encoding utf8 -Append

Write-Host "[$(Get-Date -f 'yyyy-MM-dd HH:mm:ss')] [BUILD] [Code ] Loading Class, public and private functions" -ForegroundColor Yellow

#Creating PSM1
Write-Host "[$(Get-Date -f 'yyyy-MM-dd HH:mm:ss')] [BUILD] [START] [PSM1] Building Module PSM1" -ForegroundColor Yellow
"#region namespace $($ModuleName)" | out-File -FilePath $ExportPath -Encoding utf8 -Append
Foreach($file in $MainPSM1Contents){
    Get-Content $File.FullName | out-File -FilePath $ExportPath -Encoding utf8 -Append
}
"#endregion" | out-File -FilePath $ExportPath -Encoding utf8 -Append

Write-Host "[$(Get-Date -f 'yyyy-MM-dd HH:mm:ss')] [BUILD] [END  ] [PSM1] building Module PSM1 " -ForegroundColor Yellow
#endregion

#region PSD1
Write-Host "[$(Get-Date -f 'yyyy-MM-dd HH:mm:ss')] [BUILD] [START] [PSD1] Manifest PSD1" -ForegroundColor Yellow
Write-Host "[$(Get-Date -f 'yyyy-MM-dd HH:mm:ss')] [BUILD] [PSD1 ] Adding functions to export" -ForegroundColor Yellow
$FunctionsToExport = $PublicFunctions.BaseName
Update-ModuleManifest -Path $Manifest -ModuleVersion $Version
Update-ModuleManifest -Path $Manifest -FunctionsToExport $FunctionsToExport
Write-Host "[$(Get-Date -f 'yyyy-MM-dd HH:mm:ss')] [BUILD] [END  ] [PSD1] Manifest PSD1" -ForegroundColor Yellow
#endregion

#region PesterTests
Write-Host "[$(Get-Date -f 'yyyy-MM-dd HH:mm:ss')] [BUILD] [START] [Tests] Pester Tests" -ForegroundColor Yellow

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
    
    it "[POS] [$($CurrentOS)] %FUNCTION% should not throw"{
        {%FUNCTION%} | Should -Not -Throw
    }

    it "[POS] [$($CurrentOS)] %FUNCTION% should return a PSCustomObject"{
        {%FUNCTION%} | Should -ExpectedType PSCustomObject
    }

}

Pop-Location
'@

$FunctionsToExport | ForEach-Object {
    $TestsFile = "$($TestsSourcePath)\$($_).Tests.ps1"
    if(-not(Test-Path $TestsFile)){
        New-Item -Path $TestsFile -ItemType File
        $TestsContent -replace '%FUNCTION%', $_ | out-File -FilePath $TestsFile -Encoding utf8 -Append
    }
}

Write-Host "[$(Get-Date -f 'yyyy-MM-dd HH:mm:ss')] [BUILD] [END  ] [Tests] Pester Tests" -ForegroundColor Yellow
#endregion

Write-Host "[$(Get-Date -f 'yyyy-MM-dd HH:mm:ss')] [BUILD] [END  ] Build Process" -ForegroundColor Cyan

<#
Describe 'General module control' -Tags 'FunctionalQuality'   {

    It "Import $ModuleName without errors" {
        { Import-Module -Name $ModuleFolderPath -Force -ErrorAction Stop } | Should -Not -Throw
        Get-Module $ModuleName | Should -Not -BeNullOrEmpty
    }

    It "Get-Command $ModuleName without errors" {
        { Get-Command -Module $ModuleName -ErrorAction Stop } | Should -Not -Throw
        Get-Command -Module $ModuleName | Should -Not -BeNullOrEmpty
    }

    It "Removes $ModuleName without error" {
        { Remove-Module -Name $ModuleName -ErrorAction Stop} | Should -Not -Throw
        Get-Module $ModuleName | Should -BeNullOrEmpty
    }

}
#>

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
