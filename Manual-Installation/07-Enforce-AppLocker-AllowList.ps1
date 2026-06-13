. "$PSScriptRoot\Common.ps1"
Assert-Administrator
Write-Step 'AppLocker enforcement confirmation'
Write-Warning 'Only continue after reviewing the AuditOnly report. Incorrect rules can block legitimate MoviePC applications.'
$confirmation = Read-Host 'Type ENFORCE to continue'
if ($confirmation -ne 'ENFORCE') { Write-Host 'Cancelled.'; exit 0 }
$policy = Join-Path $ProgramDataRoot 'AppLocker\MoviePC-AuditOnly.xml'
if (-not (Test-Path $policy)) { throw 'AuditOnly policy not found. Run 05-Enable-AppLocker-AuditOnly.ps1 first.' }
$xml = (Get-Content $policy -Raw).Replace('EnforcementMode="AuditOnly"','EnforcementMode="Enabled"')
$enforced = Join-Path $ProgramDataRoot 'AppLocker\MoviePC-Enforced.xml'
Set-Content $enforced $xml -Encoding UTF8
Set-AppLockerPolicy -XmlPolicy $enforced
Write-Host 'AppLocker enforcement enabled. Test MoviePC Mode immediately.'
