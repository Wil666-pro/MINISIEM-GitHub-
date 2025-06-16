EM: PowerShell-Based Log Monitoring and Alerting Toolkit

<##
Author: *William Odima*
Project: Mini-SIEM
Description: Lightweight log monitoring toolkit for Windows, built with PowerShell.
Version: 1.0
License: MIT
##>

# Global Settings
$LogOutputPath = "C:\MiniSIEM\Logs"
$AlertThreshold = 3
$LookbackMinutes = 5
$AlertPopup = $true

# Ensure Output Directory Exists
if (!(Test-Path $LogOutputPath)) {
    New-Item -ItemType Directory -Path $LogOutputPath | Out-Null
}

function Get-FailedLogins {
    $startTime = (Get-Date).AddMinutes(-$LookbackMinutes)
    Get-WinEvent -FilterHashtable @{LogName='Security'; ID=4625; StartTime=$startTime} |
        Select-Object TimeCreated, Message, Id
}

function Get-SuccessfulLogins {
    $startTime = (Get-Date).AddMinutes(-$LookbackMinutes)
    Get-WinEvent -FilterHashtable @{LogName='Security'; ID=4624; StartTime=$startTime} |
        Select-Object TimeCreated, Message, Id
}

function Export-LogReport {
    param (
        [Parameter(Mandatory)] $Events,
        [string] $Filename = "Report_$(Get-Date -Format 'yyyyMMdd_HHmmss').html"
    )
    $html = $Events | ConvertTo-Html -Property TimeCreated, Message -Title "MiniSIEM Report"
    $html | Out-File (Join-Path $LogOutputPath $Filename)
}

function Show-Alert {
    param (
        [string] $Message
    )
    if ($AlertPopup) {
        Add-Type -AssemblyName System.Windows.Forms
        [System.Windows.Forms.MessageBox]::Show($Message, "MiniSIEM Alert", 'OK', 'Warning') | Out-Null
    }
}

function Monitor-FailedLoginBurst {
    $failedLogins = Get-FailedLogins
    if ($failedLogins.Count -ge $AlertThreshold) {
        Export-LogReport -Events $failedLogins -Filename "FailedLogins_Alert.html"
        Show-Alert -Message "[!] Detected $($failedLogins.Count) failed logins in $LookbackMinutes minutes!"
    }
}

function Main {
    Write-Host "[+] Mini-SIEM started at $(Get-Date)"
    Monitor-FailedLoginBurst
    # Add additional detection logic here if needed
    Write-Host "[+] Monitoring complete"
}

# Run the Main Function
Main

#