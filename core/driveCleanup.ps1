function Invoke-DriveCleanup() {
    $disk = 'C'
    $n = 1

    # run disk cleanup using specified settings from install
    cleanmgr.exe /d $disk /sagerun:$n

    # run disk defragmentation
    Optimize-Volume -DriveLetter $disk -Analyze -Defrag -Verbose
    
    # run chkdsk
    Repair-Volume -DriveLetter C -Scan
}