. "$PSScriptRoot\Common.ps1"
Assert-Administrator
Write-Step 'Enable Windows Shell Launcher feature'
& dism.exe /Online /Enable-Feature /All /FeatureName:Client-EmbeddedShellLauncher /NoRestart | Out-Host
if ($LASTEXITCODE -eq 3010 -or $LASTEXITCODE -eq 1641) {
    Write-Warning 'Restart Windows, sign back into the administrator account, then rerun this script.'
    exit 0
}
if ($LASTEXITCODE -ne 0) { throw "DISM failed with exit code $LASTEXITCODE. Shell Launcher requires a supported Windows Enterprise, Education, or IoT Enterprise edition." }

Write-Step 'Assign MoviePC Shell to only the MoviePC account'
$sid = Resolve-MoviePcSid
$class = [wmiclass]'\\localhost\root\standardcimv2\embedded:WESL_UserSetting'
$exe = Join-Path $InstallRoot 'MoviePCShell.exe'
$cmd = '"' + $exe + '" --shell-mode'
$null = $class.SetDefaultShell('explorer.exe', 0)
$null = $class.SetCustomShell($sid, $cmd, $null, $null, 0)
$null = $class.SetEnabled($true)
Write-Host 'Shell Launcher configured. Administrator accounts keep explorer.exe.'
