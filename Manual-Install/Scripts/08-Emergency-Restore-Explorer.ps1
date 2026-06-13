$ErrorActionPreference = 'SilentlyContinue'
$sid = ([System.Security.Principal.NTAccount]'MoviePC').Translate([System.Security.Principal.SecurityIdentifier]).Value
$class = [wmiclass]'\\localhost\root\standardcimv2\embedded:WESL_UserSetting'
$null = $class.RemoveCustomShell($sid)
$null = $class.SetDefaultShell('explorer.exe', 0)
$null = $class.SetEnabled($false)
$root = 'Registry::HKEY_USERS\' + $sid
$loaded = $false
if (!(Test-Path $root)) {
    $profile = Get-CimInstance Win32_UserProfile | Where-Object SID -eq $sid | Select-Object -First 1
    if ($profile) { & reg.exe load ('HKU\' + $sid) (Join-Path $profile.LocalPath 'NTUSER.DAT') | Out-Null; $loaded = $LASTEXITCODE -eq 0 }
}
$items = @(
 @('Software\Microsoft\Windows\CurrentVersion\Policies\Explorer','NoControlPanel'),
 @('Software\Microsoft\Windows\CurrentVersion\Policies\Explorer','NoRun'),
 @('Software\Microsoft\Windows\CurrentVersion\Policies\System','DisableTaskMgr'),
 @('Software\Microsoft\Windows\CurrentVersion\Policies\System','DisableRegistryTools'),
 @('Software\Policies\Microsoft\Windows\System','DisableCMD')
)
foreach ($i in $items) { Remove-ItemProperty -Path (Join-Path $root $i[0]) -Name $i[1] -ErrorAction SilentlyContinue }
Remove-Item -LiteralPath (Join-Path $root 'Software\Policies\BraveSoftware\Brave') -Recurse -Force -ErrorAction SilentlyContinue
if ($loaded) { [gc]::Collect(); Start-Sleep -Milliseconds 200; & reg.exe unload ('HKU\' + $sid) | Out-Null }
$backup = Join-Path $env:ProgramData 'MoviePC Mode\AppLocker\Before-MoviePC-Mode.xml'
if ((Get-Command Set-AppLockerPolicy -ErrorAction SilentlyContinue) -and (Test-Path $backup)) { Set-AppLockerPolicy -XmlPolicy $backup }
Write-Host 'Explorer shell, MoviePC account policies, Brave rules, and previous AppLocker policy were restored where available.'
