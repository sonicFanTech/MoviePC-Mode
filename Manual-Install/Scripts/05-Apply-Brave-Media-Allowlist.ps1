$ErrorActionPreference = 'Stop'
$sid = ([System.Security.Principal.NTAccount]'MoviePC').Translate([System.Security.Principal.SecurityIdentifier]).Value
$root = 'Registry::HKEY_USERS\' + $sid
$loaded = $false
if (!(Test-Path $root)) {
    $profile = Get-CimInstance Win32_UserProfile | Where-Object SID -eq $sid | Select-Object -First 1
    if (!$profile) { throw 'MoviePC profile not found. Sign into MoviePC once before applying browser policy.' }
    & reg.exe load ('HKU\' + $sid) (Join-Path $profile.LocalPath 'NTUSER.DAT')
    if ($LASTEXITCODE -ne 0) { throw 'Unable to load the MoviePC user registry hive.' }
    $loaded = $true
}
function Key([string]$relative) { $path = Join-Path $root $relative; New-Item -Path $path -Force | Out-Null; return $path }
$sites = Join-Path $env:ProgramFiles 'MoviePC Mode\AllowedStreamingSites.txt'
$brave = Key 'Software\Policies\BraveSoftware\Brave'
New-ItemProperty $brave BrowserGuestModeEnabled -PropertyType DWord -Value 0 -Force | Out-Null
New-ItemProperty $brave IncognitoModeAvailability -PropertyType DWord -Value 1 -Force | Out-Null
New-ItemProperty $brave BrowserSignin -PropertyType DWord -Value 0 -Force | Out-Null
New-ItemProperty $brave SyncDisabled -PropertyType DWord -Value 1 -Force | Out-Null
New-ItemProperty $brave BraveWalletDisabled -PropertyType DWord -Value 1 -Force | Out-Null
New-ItemProperty $brave BraveRewardsDisabled -PropertyType DWord -Value 1 -Force | Out-Null
New-ItemProperty $brave BraveVPNDisabled -PropertyType DWord -Value 1 -Force | Out-Null
New-ItemProperty $brave DownloadRestrictions -PropertyType DWord -Value 3 -Force | Out-Null
$block = Key 'Software\Policies\BraveSoftware\Brave\URLBlocklist'
New-ItemProperty $block '1' -PropertyType String -Value '*' -Force | Out-Null
$allow = Join-Path $root 'Software\Policies\BraveSoftware\Brave\URLAllowlist'
Remove-Item -LiteralPath $allow -Recurse -Force -ErrorAction SilentlyContinue
New-Item -Path $allow -Force | Out-Null
$i = 1
Get-Content -LiteralPath $sites | ForEach-Object {
    $line = $_.Trim()
    if ($line -and !$line.StartsWith('#') -and !$line.StartsWith(';')) {
        New-ItemProperty $allow ([string]$i) -PropertyType String -Value $line -Force | Out-Null
        $i++
    }
}
if ($loaded) { [gc]::Collect(); Start-Sleep -Milliseconds 200; & reg.exe unload ('HKU\' + $sid) }
Write-Host "Applied $($i - 1) Brave URL-allow rules."
