# starts a windows defender quick scan
function Start-DefenderQuickScan() {
  # before scanning, the antimalware definitions are updated
  Update-MpSignature

  # start quick scan
  Start-MpScan -ScanType 'QuickScan'
}