. "$PSScriptRoot\Common.ps1"
Assert-Administrator
Write-Step 'Copy MoviePC Mode applications'
New-Item -ItemType Directory -Path $InstallRoot -Force | Out-Null
foreach ($file in 'MoviePCShell.exe','MoviePCFileExplorer.exe','MoviePCSettings.exe','MoviePCShell.ini') {
    $source = Join-Path $PayloadRoot $file
    if (-not (Test-Path $source)) { throw "Missing payload: $source. Build the release package first." }
    Copy-Item $source (Join-Path $InstallRoot $file) -Force
    Write-Host "Copied $file"
}

Write-Step 'Install Brave Browser when needed'
$braveCandidates = @(
    "$env:ProgramFiles\BraveSoftware\Brave-Browser\Application\brave.exe",
    "${env:ProgramFiles(x86)}\BraveSoftware\Brave-Browser\Application\brave.exe",
    "$env:LOCALAPPDATA\BraveSoftware\Brave-Browser\Application\brave.exe"
)
$brave = $braveCandidates | Where-Object { Test-Path $_ } | Select-Object -First 1
if (-not $brave) {
    $downloadFolder = Join-Path $ProgramDataRoot 'Downloads'
    New-Item -ItemType Directory -Path $downloadFolder -Force | Out-Null
    $setup = Join-Path $downloadFolder 'BraveBrowserSetup.exe'
    Invoke-WebRequest 'https://laptop-updates.brave.com/latest/winx64' -OutFile $setup
    Start-Process $setup -ArgumentList '--silent --install' -Wait
    $brave = $braveCandidates | Where-Object { Test-Path $_ } | Select-Object -First 1
}
if ($brave) {
    Write-Host "Brave: $brave"
    $ini = Join-Path $InstallRoot 'MoviePCShell.ini'
    $content = Get-Content $ini -Raw
    $content = [regex]::Replace($content, '(?m)^BrowserPath=.*$', "BrowserPath=$brave")
    Set-Content $ini $content -Encoding Unicode
} else { Write-Warning 'Brave was not detected after installation. Web playback will not work until Brave is installed.' }

Write-Step 'Install private VLC copy for MoviePC Mode'
$vlcTarget = Join-Path $InstallRoot 'Apps\VLC'
$vlcExe = Join-Path $vlcTarget 'vlc.exe'
if (-not (Test-Path $vlcExe)) {
    $downloadFolder = Join-Path $ProgramDataRoot 'Downloads'
    $stage = Join-Path $ProgramDataRoot 'Temp\VLC-Extract'
    New-Item -ItemType Directory -Path $downloadFolder -Force | Out-Null
    Remove-Item $stage -Recurse -Force -ErrorAction SilentlyContinue
    New-Item -ItemType Directory -Path $stage -Force | Out-Null
    $zip = Join-Path $downloadFolder 'vlc-3.0.23-win64.zip'
    Invoke-WebRequest 'https://get.videolan.org/vlc/3.0.23/win64/vlc-3.0.23-win64.zip' -OutFile $zip
    Expand-Archive $zip -DestinationPath $stage -Force
    $source = Get-ChildItem $stage -Directory | Select-Object -First 1
    if (-not $source -or -not (Test-Path (Join-Path $source.FullName 'vlc.exe'))) { throw 'VLC archive did not contain vlc.exe.' }
    Remove-Item $vlcTarget -Recurse -Force -ErrorAction SilentlyContinue
    New-Item -ItemType Directory -Path (Split-Path $vlcTarget -Parent) -Force | Out-Null
    Move-Item $source.FullName $vlcTarget -Force
    Remove-Item $stage -Recurse -Force -ErrorAction SilentlyContinue
}
$ini = Join-Path $InstallRoot 'MoviePCShell.ini'
$content = Get-Content $ini -Raw
$content = [regex]::Replace($content, '(?m)^VLCPath=.*$', "VLCPath=$vlcExe")
Set-Content $ini $content -Encoding Unicode
Write-Host "VLC: $vlcExe"
