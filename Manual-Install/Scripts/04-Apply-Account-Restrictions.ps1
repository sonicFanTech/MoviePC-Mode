$ErrorActionPreference = 'Stop'
$sid = ([System.Security.Principal.NTAccount]'MoviePC').Translate([System.Security.Principal.SecurityIdentifier]).Value
$root = 'Registry::HKEY_USERS\' + $sid
$loaded = $false
if (!(Test-Path $root)) {
    $profile = Get-CimInstance Win32_UserProfile | Where-Object SID -eq $sid | Select-Object -First 1
    if (!$profile) { throw 'MoviePC profile not found. Sign into MoviePC once, then return to the administrator account.' }
    & reg.exe load ('HKU\' + $sid) (Join-Path $profile.LocalPath 'NTUSER.DAT')
    if ($LASTEXITCODE -ne 0) { throw 'Unable to load the MoviePC user registry hive.' }
    $loaded = $true
}
function Key([string]$relative) { $path = Join-Path $root $relative; New-Item -Path $path -Force | Out-Null; return $path }
New-ItemProperty (Key 'Software\Microsoft\Windows\CurrentVersion\Policies\Explorer') NoControlPanel -PropertyType DWord -Value 1 -Force | Out-Null
New-ItemProperty (Key 'Software\Microsoft\Windows\CurrentVersion\Policies\Explorer') NoRun -PropertyType DWord -Value 1 -Force | Out-Null
New-ItemProperty (Key 'Software\Microsoft\Windows\CurrentVersion\Policies\System') DisableTaskMgr -PropertyType DWord -Value 1 -Force | Out-Null
New-ItemProperty (Key 'Software\Microsoft\Windows\CurrentVersion\Policies\System') DisableRegistryTools -PropertyType DWord -Value 1 -Force | Out-Null
New-ItemProperty (Key 'Software\Policies\Microsoft\Windows\System') DisableCMD -PropertyType DWord -Value 1 -Force | Out-Null
if ($loaded) { [gc]::Collect(); Start-Sleep -Milliseconds 200; & reg.exe unload ('HKU\' + $sid) }
Write-Host 'MoviePC account restrictions applied.'
