function Get-WinUpdates() {
    # updates group policy
    Invoke-GPUpdate
    
    # check for available Windows updates (uses PSWindowsUpdate module)
    Get-WindowsUpdate

    # install all available updates without prompting user
    Install-WindowsUpdate -AcceptAll
}