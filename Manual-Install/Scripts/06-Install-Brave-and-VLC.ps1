$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'
$downloads = Join-Path $env:TEMP 'MoviePCModeDownloads'
$installDir = Join-Path $env:ProgramFiles 'MoviePC Mode'
New-Item -ItemType Directory -Path $downloads -Force | Out-Null
$braveCandidates = @((Join-Path $env:ProgramFiles 'BraveSoftware\Brave-Browser\Application\brave.exe'))
if (${env:ProgramFiles(x86)}) { $braveCandidates += (Join-Path ${env:ProgramFiles(x86)} 'BraveSoftware\Brave-Browser\Application\brave.exe') }
if (!($braveCandidates | Where-Object { Test-Path $_ } | Select-Object -First 1)) {
    $setup = Join-Path $downloads 'BraveBrowserSetup.exe'
    Write-Host 'Downloading Brave from the official Brave endpoint...'
    Invoke-WebRequest -UseBasicParsing -Uri 'https://laptop-updates.brave.com/latest/winx64' -OutFile $setup
    $process = Start-Process -FilePath $setup -ArgumentList '--install','--silent','--system-level' -Wait -PassThru
    if ($process.ExitCode -ne 0) { throw "Brave installer returned $($process.ExitCode)" }
}
$zip = Join-Path $downloads 'vlc-3.0.23-win64.zip'
$extract = Join-Path $downloads 'vlc-extracted'
$vlcDir = Join-Path $installDir 'Apps\VLC'
Write-Host 'Downloading VLC from VideoLAN...'
Invoke-WebRequest -UseBasicParsing -Uri 'https://get.videolan.org/vlc/3.0.23/win64/vlc-3.0.23-win64.zip' -OutFile $zip
Remove-Item -LiteralPath $extract -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -LiteralPath $vlcDir -Recurse -Force -ErrorAction SilentlyContinue
Expand-Archive -LiteralPath $zip -DestinationPath $extract -Force
$source = Get-ChildItem -LiteralPath $extract -Directory | Select-Object -First 1
New-Item -ItemType Directory -Path $vlcDir -Force | Out-Null
Copy-Item -Path (Join-Path $source.FullName '*') -Destination $vlcDir -Recurse -Force
Remove-Item -LiteralPath $downloads -Recurse -Force -ErrorAction SilentlyContinue
Write-Host 'Brave and the private MoviePC VLC copy are ready.'
