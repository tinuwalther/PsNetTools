function Set-HeaderLines{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [Object]$Path
    )

$mdcontent = @"
# Table of Contents`n
- [Table of Contents](#table-of-contents) 
- [PsNetTools](#psnettools) 

# PsNetTools`n
PsNetTools is a cross platform PowerShell module to test some network features on Windows and Mac.`n
![PsNetTools](../Images/NewPsNetTools.png)`n
Image generated with [PSWordCloud](https://github.com/vexx32/PSWordCloud) by Joel Sallow.
"@
$mdcontent | Out-File -FilePath $Path -Append
}

function Get-PsNetComment {

    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [String]$Path
    )

    begin {
    }
    
    process {

        [System.Collections.ArrayList]$file = Get-Content $Path
        [System.Collections.ArrayList]$content = @()

        $start = $file -match '<#'
        $ende  = $file -match '#>'
        $startindex = $file.IndexOf($start)
        $endeindex  = $file.IndexOf($ende)

        for ($i = 0; $i -lt $file.count; $i++){
            if($i -eq $startindex){
                for ($i = $startindex + 1; $i -lt $endeindex -1; $i++){
                    $content += $file[$i]
                }
            }
        }

        return $content
    }
    end {
    }
}

function Get-SingleString {
    
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [Object]$Content,

        [Parameter(Mandatory = $true)]
        [String]$Search,

        [Parameter(Mandatory = $true)]
        [String]$Path
    )

    begin{
        if($Search -match '.SYNOPSIS' ){
            $ret = "`n# "
        }
    }

    process{
        $stringSearch = $content -match $Search
        $indexSearch  = $content.IndexOf($stringSearch) + 1
        for ($i = 0; $i -lt $content.count; $i++){
            if($indexSearch -eq $i){
                "$ret$($content[$i].Trim())`n" | Out-File -FilePath $Path -Append
            }
        }
    }

    end{
    }
}

function Get-ParameterString {

    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [Object]$Content,

        [Parameter(Mandatory = $true)]
        [String]$Search,

        [Parameter(Mandatory = $true)]
        [String]$Path
    )

    begin{
        $stringSearch = $content -match $Search
    }

    process{
        if($stringSearch.Count -gt 1){
            # Multiple Comment found
            foreach($item in $stringSearch){
                $indexSearch = $content.IndexOf($item)
                for ($i = 0; $i -lt $content.count; $i++){
                    if($indexSearch -eq $i){
                        "$($content[$i].Trim())`n" | Out-File -FilePath $Path -Append
                    }
                    if($indexSearch + 1 -eq $i){
                        "- $($content[$i].Trim())`n" | Out-File -FilePath $Path -Append
                    }
                }
            }
        }
        else{
            # Single Comment found
            $indexSearch  = $content.IndexOf($stringSearch)
            for ($i = 0; $i -lt $content.count; $i++){
                if($indexSearch -eq $i){
                    "$($content[$i].Trim())`n" | Out-File -FilePath $Path -Append
                }
                if($indexSearch + 1 -eq $i){
                    "- $($content[$i].Trim())`n" | Out-File -FilePath $Path -Append
                }
            }
        }
    }

    end{
    }
}

function Get-ExampleString {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [Object]$Content,

        [Parameter(Mandatory = $true)]
        [String]$Search,

        [Parameter(Mandatory = $true)]
        [String]$Path
    )

    begin{
        $stringSearch = $content -match $Search
    }

    process{
        if($stringSearch.Count -gt 1){
            # Multiple Comment found
            foreach($item in $stringSearch){
                $indexSearch = $content.IndexOf($item)
                for ($i = 0; $i -lt $content.count; $i++){
                    if($indexSearch -eq $i){
                        "$($content[$i].Trim())`n" | Out-File -FilePath $Path -Append
                    }
                    if($indexSearch + 1 -eq $i){
                        "- $($content[$i].Trim())`n" | Out-File -FilePath $Path -Append
                    }
                }
            }
        }
        else{
            # Single Comment found
            $indexSearch  = $content.IndexOf($stringSearch)
            for ($i = 0; $i -lt $content.count; $i++){
                if($indexSearch -eq $i){
                    "$($content[$i].Trim())`n" | Out-File -FilePath $Path -Append
                }
                if($indexSearch + 1 -eq $i){
                    "- $($content[$i].Trim())`n" | Out-File -FilePath $Path -Append
                }
            }
        }
    }

    end{
    }
}

$Current          = (Split-Path -Path $MyInvocation.MyCommand.Path)
$Root             = ((Get-Item $Current).Parent).FullName
$ModuleName       = "PsNetTools"
$CodeSourcePath   = Join-Path -Path $Root -ChildPath "Code"
$DocsSourcePath   = Join-Path -Path $Root -ChildPath "Docs"
$ExportPath       = Join-Path -Path $DocsSourcePath -ChildPath "$($ModuleName).md"

if(Test-Path -Path $ExportPath){$ExportPath | Remove-item}

Set-HeaderLines -Path $ExportPath

Get-ChildItem "$CodeSourcePath\Functions\Public" -Filter '*.ps1' | ForEach-Object {

    $comments    = Get-PsNetComment -Path $_.FullName
    Get-SingleString    -Content $comments -Search '.SYNOPSIS'    -Path $ExportPath
    Get-SingleString    -Content $comments -Search '.DESCRIPTION' -Path $ExportPath
    Get-ParameterString -Content $comments -Search '.PARAMETER'   -Path $ExportPath
    "``````powershell" | Out-File -FilePath $ExportPath -Append
    Get-ExampleString -Content $comments -Search '.EXAMPLE' -Path $ExportPath
    "``````" | Out-File -FilePath $ExportPath -Append

}

'[ [Top] ](#table-of-contents)' | Out-File -FilePath $ExportPath -Append