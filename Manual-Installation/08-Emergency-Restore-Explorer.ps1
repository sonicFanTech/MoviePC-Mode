. "$PSScriptRoot\Common.ps1"
Assert-Administrator
Write-Step 'Emergency Explorer-shell restore'
$sid = Resolve-MoviePcSid
try {
    $class = [wmiclass]'\\localhost\root\standardcimv2\embedded:WESL_UserSetting'
    try { $null = $class.RemoveCustomShell($sid) } catch {}
    try { $null = $class.SetDefaultShell('explorer.exe',0) } catch {}
    try { $null = $class.SetEnabled($false) } catch {}
} catch { Write-Warning $_.Exception.Message }
Invoke-WithUserHive {
    param($root)
    $items = @(
        @('Software\Microsoft\Windows\CurrentVersion\Policies\Explorer','NoControlPanel'),
        @('Software\Microsoft\Windows\CurrentVersion\Policies\Explorer','NoRun'),
        @('Software\Microsoft\Windows\CurrentVersion\Policies\System','DisableTaskMgr'),
        @('Software\Microsoft\Windows\CurrentVersion\Policies\System','DisableRegistryTools'),
        @('Software\Policies\Microsoft\Windows\System','DisableCMD')
    )
    foreach ($item in $items) { Remove-ItemProperty -Path (Join-Path $root $item[0]) -Name $item[1] -ErrorAction SilentlyContinue }
    Remove-Item -Path (Join-Path $root 'Software\Policies\BraveSoftware\Brave') -Recurse -Force -ErrorAction SilentlyContinue
}
$backup = Join-Path $ProgramDataRoot 'AppLocker\Before-MoviePC-Mode.xml'
if ((Get-Command Set-AppLockerPolicy -ErrorAction SilentlyContinue) -and (Test-Path $backup)) { Set-AppLockerPolicy -XmlPolicy $backup }
Write-Host 'Explorer restore complete. Sign out or restart Windows.'
