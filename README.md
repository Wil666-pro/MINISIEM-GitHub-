# README.md Content Below:
# ============================

<##
# Mini-SIEM
A lightweight PowerShell-based monitoring and alerting tool for Windows Security logs. Built for blue teamers and SOC analysts who need quick insights into failed logins and other suspicious events without expensive SIEM tools.

## Features
- Detects failed login attempts (Event ID 4625)
- Alerts on bursts of login failures within a configurable time window
- Exports incident data to readable HTML reports
- Optional desktop pop-up alerts

## Setup Instructions
1. Clone or download the script `MiniSIEM.ps1`
2. Create a folder `C:\MiniSIEM\Logs` (auto-created by the script)
3. Run the script with admin privileges in PowerShell:
```powershell
powershell -ExecutionPolicy Bypass -File .\MiniSIEM.ps1
```

## Scheduled Task (Optional)
To run Mini-SIEM every 10 minutes:
```powershell
$action = New-ScheduledTaskAction -Execute 'PowerShell.exe' -Argument '-ExecutionPolicy Bypass -File "C:\MiniSIEM\MiniSIEM.ps1"'
$trigger = New-ScheduledTaskTrigger -Once -At (Get-Date).AddMinutes(1) -RepetitionInterval (New-TimeSpan -Minutes 10) -RepetitionDuration ([TimeSpan]::MaxValue)
Register-ScheduledTask -TaskName "MiniSIEM Monitor" -Action $action -Trigger $trigger -RunLevel Highest -User 'SYSTEM'
```

## Folder Structure
```
/MiniSIEM/
 ┣ MiniSIEM.ps1
 ┣ README.md
 ┗ /Logs/
    ┗ Report_YYYYMMDD_HHMMSS.html
```

## License
MIT License
##>