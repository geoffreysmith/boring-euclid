#Requires -RunAsAdministrator
#Requires -Version 7.1

<#
    	.SYNOPSIS
    	This script checks the current configuration and makes  the necessary changes to allow containers and kubernetes to build and run.    	Version: v5.12.2
    	Date: 09.01.2021
    	.DESCRIPTION
    	Place the "#" char before function if you don't want to run it
    	Remove the "#" char before function if you want to run it
    	Every tweak in the preset file has its' corresponding function to restore the default settings
    	.EXAMPLE Run the whole script
    	.\install.ps1
    	.NOTES
    	Supported Windows 10 versions
    	Versions: 2004/20H2/21H1/21H2
    	Builds: 19041/19042/19043/19044
    	Editions: Home/Pro/Enterprise
    	Architecture: x64
    	.NOTES
    	Set execution policy to be able to run scripts only in the current PowerShell session:
    		Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force
    	.NOTES
    	Running the script is best done on a fresh install because running it on wrong tweaked system may result in errors occurring
    	.NOTES
    	All events are logged to the Windows EventLog, useful for unattended runs.
        Use option -Verbose in order to see the verbose output messages.
        .NOTES 
        Uses golang style folder conventions:
            /workspace/src/[repository-provider]/[repository-owner]/[repository-name]
        .NOTES
        Default WSL user: be
        .NOTES
        Ubuntu_2004
    	.NOTES
    	https://github.com/geoffreysmith/boring-euclid#>
#>

# Support -Verbose option
[CmdletBinding()]

Function Write-Log
{
    $Message = $args[0]
    Write-EventLog -LogName Application -Source $EventSource -EntryType Information -EventId 1 -Message $Message
}

Function Write-VerboseLog
{
    $Message = $args[0]
    Write-Verbose $Message
    Write-Log $Message
}

Function Write-HostLog
{
    $Message = $args[0]
    Write-Output $Message
    Write-Log $Message
}

$chocolateyAppList = "microsoft-windows-terminal,7zip,vscode,ssms,sqllocaldb,sshfs,openssh"
$dismAppList = "IIS-ASPNET45,IIS-CertProvider,IIS-ManagementService"

if ([string]::IsNullOrWhiteSpace($chocolateyAppList) -eq $false -or [string]::IsNullOrWhiteSpace($dismAppList) -eq $false)
{
    try{
        choco config get cacheLocation
    }catch{
        Write-HostLog "Chocolatey not detected, trying to install now"
        iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    }
}

if ([string]::IsNullOrWhiteSpace($chocolateyAppList) -eq $false){   
    Write-HostLog "Chocolatey Apps Specified"  
    
    $appsToInstall = $chocolateyAppList -split "," | foreach { "$($_.Trim())" }

    foreach ($app in $appsToInstall)
    {
        Write-HosLog  "Installing $app"
        & choco install $app /y | Write-Output
    }
}

if ([string]::IsNullOrWhiteSpace($dismAppList) -eq $false){
    Write-HostLog "DISM Features Specified"    

    $appsToInstall = $dismAppList -split "," | foreach { "$($_.Trim())" }

    foreach ($app in $appsToInstall)
    {
        Write-Host "Installing $app"
        & choco install $app /y /source windowsfeatures | Write-Output
    }
}