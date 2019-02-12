[CmdletBinding()]
Param()
<#
#Requires -Version 5.0
.SYNOPSIS
Script to aid in logging
.DESCRIPTION
Run This script once = keeps on running in the background until being killed. It's still a process, not a service.
Run this script while it's already running:  
* process is killed.
* pcap files are being zipped in a new archive.
* All pcap files are deleted to keep the working directory clean.
* Process is started again.
#>

#Location of Tshark exe file on the local computer. Splitting up exe and arguments for easier editing
$TsharkDir      = 'c:\program files\wireshark\'
$TsharkExe      = "tshark.exe"
$Seconds        = 60
$Duration       = "duration:$Seconds"
$Files          = "files:5"
$Sleep          = $Seconds + 5

#Where the pcaps will be saved
$OutputDir      = "$env:USERPROFILE\Documents\pcapstest\"
$OutputFile     = "Outputfile.pcap"
$Output         = "$OutputDir$OutputFile"

$TsharkAlive = Get-Process tshark -ErrorAction SilentlyContinue

function StartTshark 
    {
    Write-Verbose "Starting Tshark in hidden fashion"
    Start-Process -FilePath $TsharkExe -WorkingDirectory $TsharkDir -ArgumentList "-b $Duration -b $Files -w $Output" -WindowStyle Hidden -Verbose
    }
if ($TsharkAlive)
    {
        Write-Verbose "Tshark is already running. Will zip current captures"
        Start-Sleep $Sleep
        Stop-Process -ProcessName tshark -Force -Verbose
        $TimeStamp  = Get-Date -Format o | foreach {$_ -replace ":", "-"}
        $Zipfile    = "$env:USERPROFILE\Documents\$TimeStamp.zip"
        Compress-Archive -Path $OutputDir -DestinationPath $Zipfile -Verbose
        Write-Verbose "Done ziping"
        if (Test-Path $Zipfile) 
            {
            Write-Verbose "Zip file exists. Removing old pcaps"
            Get-ChildItem $OutputDir -Include *.pcap -Recurse | Remove-Item -Verbose
            }
        else 
        {
        Write-Verbose "Ziping failed. User has no write permissions?"    
        }
        Start-Sleep 5
        StartTshark
    }
else 
    {
        
    if (Test-Path $OutputDir) 
        {
        StartTshark
        }    
    else 
        {
        New-Item $OutputDir -ItemType Directory -Verbose
        StartTshark
        }
    }

