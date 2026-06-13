Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$ScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$PayloadRoot = Join-Path $ScriptRoot 'Payload'
$InstallRoot = Join-Path $env:ProgramFiles 'MoviePC Mode'
$ProgramDataRoot = Join-Path $env:ProgramData 'MoviePC Mode'
$MovieAccount = 'MoviePC'

function Assert-Administrator {
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = [Security.Principal.WindowsPrincipal]::new($identity)
    if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        throw 'Run this script from an elevated PowerShell window or use the matching .cmd wrapper with Run as administrator.'
    }
}

function Write-Step([string]$Text) {
    Write-Host "`n=== $Text ===" -ForegroundColor Cyan
}

function Resolve-MoviePcSid {
    $account = Get-CimInstance Win32_UserAccount -Filter "LocalAccount=True AND Name='$MovieAccount'" | Select-Object -First 1
    if (-not $account) { throw "Local account '$MovieAccount' does not exist." }
    return $account.SID
}

function Invoke-WithUserHive([scriptblock]$Action) {
    $sid = Resolve-MoviePcSid
    $root = "Registry::HKEY_USERS\$sid"
    $loaded = $false
    if (-not (Test-Path $root)) {
        $profile = Get-CimInstance Win32_UserProfile | Where-Object SID -eq $sid | Select-Object -First 1
        if (-not $profile) { throw 'The MoviePC profile does not exist yet. Sign in once or rerun the account-creation script.' }
        & reg.exe load "HKU\$sid" (Join-Path $profile.LocalPath 'NTUSER.DAT') | Out-Host
        if ($LASTEXITCODE -ne 0) { throw 'Unable to load the MoviePC profile registry hive.' }
        $loaded = $true
    }
    try { & $Action $root }
    finally {
        if ($loaded) {
            [gc]::Collect()
            Start-Sleep -Milliseconds 200
            & reg.exe unload "HKU\$sid" | Out-Host
        }
    }
}

function Ensure-Key([string]$Path) {
    New-Item -Path $Path -Force | Out-Null
    return $Path
}

function Get-StreamingAllowlist {
    @(
        'about:blank',
        'brave://*',
        'chrome://*',
        '*://*.netflix.com/*',
        '*://*.hulu.com/*',
        '*://*.disneyplus.com/*',
        '*://*.max.com/*',
        '*://*.hbomax.com/*',
        '*://*.primevideo.com/*',
        '*://*.amazon.com/gp/video/*',
        '*://*.paramountplus.com/*',
        '*://*.peacocktv.com/*',
        '*://*.tubitv.com/*',
        '*://*.pluto.tv/*',
        '*://*.roku.com/*',
        '*://*.plex.tv/*',
        '*://*.crunchyroll.com/*',
        '*://*.youtube.com/*',
        '*://youtu.be/*',
        '*://*.imdb.com/*'
    )
}

function Apply-Brave-Allowlist([string]$Root) {
    $brave = Ensure-Key (Join-Path $Root 'Software\Policies\BraveSoftware\Brave')
    New-ItemProperty $brave BrowserGuestModeEnabled -PropertyType DWord -Value 0 -Force | Out-Null
    New-ItemProperty $brave BrowserAddPersonEnabled -PropertyType DWord -Value 0 -Force | Out-Null
    New-ItemProperty $brave IncognitoModeAvailability -PropertyType DWord -Value 1 -Force | Out-Null
    New-ItemProperty $brave DeveloperToolsAvailability -PropertyType DWord -Value 2 -Force | Out-Null
    New-ItemProperty $brave PasswordManagerEnabled -PropertyType DWord -Value 0 -Force | Out-Null
    New-ItemProperty $brave DownloadRestrictions -PropertyType DWord -Value 3 -Force | Out-Null
    Remove-Item (Join-Path $brave 'URLBlocklist') -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item (Join-Path $brave 'URLAllowlist') -Recurse -Force -ErrorAction SilentlyContinue
    $block = Ensure-Key (Join-Path $brave 'URLBlocklist')
    New-ItemProperty $block '1' -PropertyType String -Value '*' -Force | Out-Null
    $allow = Ensure-Key (Join-Path $brave 'URLAllowlist')
    $index = 1
    foreach ($site in Get-StreamingAllowlist) {
        New-ItemProperty $allow ([string]$index) -PropertyType String -Value $site -Force | Out-Null
        $index++
    }
}
