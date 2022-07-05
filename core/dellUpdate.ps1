Set-Location -LiteralPath "${env:ProgramFiles(x86)}\Dell\CommandUpdate"

cmd.exe /c dcu-cli.exe /scan "&&" dcu-cli.exe /applyUpdates -reboot enable

#-outputLog -reboot enable -silent