$ErrorActionPreference = 'Stop'
$sid = ([System.Security.Principal.NTAccount]'MoviePC').Translate([System.Security.Principal.SecurityIdentifier]).Value
$class = [wmiclass]'\\localhost\root\standardcimv2\embedded:WESL_UserSetting'
$exe = Join-Path $env:ProgramFiles 'MoviePC Mode\MoviePCShell.exe'
$cmd = '"' + $exe + '" --shell-mode'
Write-Host "SetDefaultShell('explorer.exe', 0)"
$null = $class.SetDefaultShell('explorer.exe', 0)
Write-Host "SetCustomShell($sid, $cmd, ..., 0)"
$null = $class.SetCustomShell($sid, $cmd, $null, $null, 0)
Write-Host 'SetEnabled($true)'
$null = $class.SetEnabled($true)
Write-Host 'Shell Launcher configuration completed.'
