. "$PSScriptRoot\Common.ps1"
Assert-Administrator
Write-Step 'Generate AppLocker audit report'
$folder = Join-Path $ProgramDataRoot 'AppLocker'
New-Item -ItemType Directory -Path $folder -Force | Out-Null
$report = Join-Path $folder 'AppLocker-Audit-Report.txt'
'MoviePC Mode AppLocker audit report' | Set-Content $report -Encoding UTF8
('Generated: ' + (Get-Date)) | Add-Content $report
$logs = @('Microsoft-Windows-AppLocker/EXE and DLL','Microsoft-Windows-AppLocker/MSI and Script','Microsoft-Windows-AppLocker/Packaged app-Execution','Microsoft-Windows-AppLocker/Packaged app-Deployment')
foreach ($log in $logs) {
    "`n===== $log =====" | Add-Content $report
    try { Get-WinEvent -LogName $log -MaxEvents 400 | Select-Object TimeCreated,Id,LevelDisplayName,Message | Format-List | Out-String -Width 240 | Add-Content $report }
    catch { ('Unable to read log: ' + $_.Exception.Message) | Add-Content $report }
}
Start-Process notepad.exe $report
