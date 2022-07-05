# imported modules
Import-Module -Name PSWindowsUpdate

# include statements
. ./settings.ps1
. ./driveCleanup.ps1
. ./logger.ps1
. ./winUpdate.ps1
. ./dellUpdate.ps1
. ./virusScan.ps1

# workflow definition
workflow Start-Maintenance {
  Invoke-DriveCleanup
  Get-WinUpdates
  Restart-Computer -Wait
  Start-DefenderQuickScan
}

# run defined workflow
Start-Maintenance
