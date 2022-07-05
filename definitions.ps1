. "H:\Redfern\RHC_Share\IT\Max's Automation Scripts\common.ps1"

function Install-Client() {
    $installSource = "\\group.clemson.edu\group\Redfern\RHC_Share\IT\Max's Automation Scripts"
    Add-Type -AssemblyName System.Windows.Forms

    

    $DestBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
    $DestBrowser.RootFolder = 'MyComputer'
    $DestBrowser.Description = 'Select install destination'
    $null = $DestBrowser.ShowDialog()
    $installDest = $DestBrowser.SelectedPath

    Write-Host('')
    Write-Host('Creating directories.')
    $parent = $installDest + '\Redfern IT Maintenance'
    # create directory for storing logs of critical system events
    New-Item -Path $parent -Name 'logs' -ItemType 'directory'

    Write-Host('')
    Write-Host('Extracting files from source.')
    Set-Location -LiteralPath $installSource
    Expand-Archive -Path '.\client.zip' -DestinationPath $parent

    # move install log
    $temp = $installDest + '\tempFolder'

    Write-Host('')
    Write-Host('Installing required modules.')
    Set-Location $parent
    # install required powershell modules without user confirmation
    Install-Module -Name PSWindowsUpdate -Force

    $paths = $installDest, $installSource, $parent

    return $paths
}

function Install-SetPreferences ($temp) {
  # configures disk cleanup settings without user interaction, selecting all types of temporary files to be cleared
  # cleanup with these settings can be accessed by using the /sagerun:1 switch (the settings are stored in a registry key)
  # essentially it is the same as opening disk cleanup and selecting every checkbox
  Write-Host('')
  Write-Host('Configuring Disk Cleanup to run with settings: /sagerun:1.')
  Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\*' | ForEach-Object {
    New-ItemProperty -Path $_.PSPath -Name StateFlags0001 -Value 2 -PropertyType DWord -Force
  };

  Write-Host('')
  Write-Host('Creating new scheduled task: redfern_maintenance.')
  $temp = $temp + '\scripts\workflows.ps1'
  # creates a new task action that will execute the workflows.ps1 script with powershell
  $action = (New-ScheduledTaskAction -Execute 'Powershell.exe' -Argument $temp)
  # creates and registers a task called 'redfern_maintenance'
  Register-ScheduledTask -TaskName 'redfern_maintenance' -Action $action -Force
}