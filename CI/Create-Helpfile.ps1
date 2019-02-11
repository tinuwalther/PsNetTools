function Get-PsNetComment {

    <#

    .SYNOPSIS
       Get-PsNetComment

    .DESCRIPTION
       Add an entry in the hosts-file

    .PARAMETER Path
       Path to the 

    .PARAMETER Markdown
       Path to the 

    .NOTES
       Author: Martin Walther
 
    .EXAMPLE
       Get-PsNetComment -Path 127.0.0.1 -Markdown tinu

    #>

    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [String]$Path,

        [Parameter(Mandatory = $true)]
        [String]$Markdown
        )

    begin {
        $indexsynopsis    = $null
        $indexdescription = $null
        $indexparameter   = $null
        $indexexample     = $null
        $resultset        = @()
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
                for ($i = $startindex; $i -lt $endeindex -1; $i++){
                    $content += $file[$i]
                }
            }
        }

        $stringsynopsis    = $content -match '.SYNOPSIS'
        $stringdescription = $content -match '.DESCRIPTION'
        $stringparameter   = $content -match '.PARAMETER'
        $stringexample     = $content -match '.EXAMPLE'

        $indexsynopsis    = $content.IndexOf($stringsynopsis) + 1
        $indexdescription = $content.IndexOf($stringdescription) + 1
        $indexparameter   = $content.IndexOf($stringparameter) + 1
        $indexexample     = $content.IndexOf($stringexample) + 1
        
        for ($i = 0; $i -lt $content.count; $i++){
            if($indexsynopsis -eq $i){
                $SYNOPSIS = $content[$i].Trim()
            }
            if($indexdescription -eq $i){
                $DESCRIPTION = $content[$i].Trim()
            }
            if($indexparameter -eq $i){
                $PARAMETER = $content[$i].Trim()
            }
            if($indexexample -eq $i){
                $EXAMPLE = $content[$i].Trim()
            }
        }

$mdcontent = @"
# $($SYNOPSIS)`n
DESCRIPTION: $($DESCRIPTION)`n
PARAMETER  : $($PARAMETER)`n
EXAMPLE:`n
``````powershell
$($EXAMPLE)
``````

"@

        $mdcontent | Out-File -FilePath $Markdown -Append
    }
    end {
    }
}

$Current          = (Split-Path -Path $MyInvocation.MyCommand.Path)
$Root             = ((Get-Item $Current).Parent).FullName
$ModuleName       = "PsNetTools"
#$ModuleFolderPath = Join-Path -Path $Root -ChildPath $ModuleName
$CodeSourcePath   = Join-Path -Path $Root -ChildPath "Code"
$DocsSourcePath   = Join-Path -Path $Root -ChildPath "Docs"
$ExportPath       = Join-Path -Path $DocsSourcePath -ChildPath "$($ModuleName).md"

if(Test-Path -Path $ExportPath){$ExportPath | Remove-item}

Get-ChildItem "$CodeSourcePath\Functions\Public" -Filter '*.ps1' | ForEach-Object {
    Get-PsNetComment -Path $_.FullName -Markdown $ExportPath
}
