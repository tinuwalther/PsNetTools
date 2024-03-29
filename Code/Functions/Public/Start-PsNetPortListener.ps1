﻿function Start-PsNetPortListener {

    <#

    .SYNOPSIS
       Start a TCP Portlistener

    .DESCRIPTION
       Temporarily listen on a given TCP port for connections dumps connections to the screen

    .PARAMETER TcpPort
       The TCP port that the listener should attach to

    .PARAMETER MaxTimeout
       MaxTimeout in milliseconds to wait, default is 5000

    .EXAMPLE
       Start-PsNetPortListener -TcpPort 443, Listening on TCP port 443, press CTRL+C to cancel

    .INPUTS

    .OUTPUTS
       PSCustomObject

    .NOTES
       Author: Martin Walther

    .LINK
       https://github.com/tinuwalther/PsNetTools

    #>

    [CmdletBinding(SupportsShouldProcess=$True)]
    param(
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            Position = 0
        )]
        [Int]$TcpPort,

        [Parameter(
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            Position = 1
        )]
        [Int]$MaxTimeout = 5000
    )
    
    begin{
        $function = $($MyInvocation.MyCommand.Name)
        Write-Verbose "Running $function"
    }

    process{
        $item = $TcpPort
        if ($PSCmdlet.ShouldProcess($item)){
            $endpoint = New-Object System.Net.IPEndPoint ([System.Net.IPAddress]::Any, $TcpPort)    
            $listener = New-Object System.Net.Sockets.TcpListener $endpoint
            
            $listener.server.ReceiveTimeout = $MaxTimeout
            $listener.start()  

            try {
                Write-Host "Listening on TCP port $TcpPort, press CTRL+C to cancel"

                While ($true){
                    if (!$listener.Pending()){
                        Start-Sleep -Seconds 1
                        continue
                    }
                    $client = $listener.AcceptTcpClient()
                    $client.client.RemoteEndPoint | Add-Member -NotePropertyName DateTime -NotePropertyValue (Get-Date) -PassThru
                    $client.close()
                }
            }
            catch {
                $obj = [PSCustomObject]@{
                    Succeeded          = $false
                    Function           = $function
                    Message            = $($_.Exception.Message)
                    Category           = $($_.CategoryInfo).Category
                    Exception          = $($_.Exception.GetType().FullName)
                    CategoryActivity   = $($_.CategoryInfo).Activity
                    CategoryTargetName = $($_.CategoryInfo).TargetName
                }
                $obj
                $error.Clear()
            }
            finally{
                $listener.stop()
                Write-host "Listener Closed Safely"
            }
        }
    }

    end{
        Write-Verbose "Finish $function"
    }
}
