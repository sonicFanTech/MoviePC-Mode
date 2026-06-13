. "$PSScriptRoot\Common.ps1"
Assert-Administrator
Write-Step 'Enable Application Identity service'
& sc.exe config AppIDSvc start= auto | Out-Host
Start-Service AppIDSvc -ErrorAction SilentlyContinue
Write-Step 'Generate and apply AppLocker AuditOnly policy'
$sid = Resolve-MoviePcSid
$admins = 'S-1-5-32-544'
function New-Rule([string]$Name,[string]$RuleSid,[string]$Path) {
    $id = [guid]::NewGuid().ToString('B')
    "    <FilePathRule Id=`"$id`" Name=`"$Name`" Description=`"MoviePC Mode audit rule`" UserOrGroupSid=`"$RuleSid`" Action=`"Allow`"><Conditions><FilePathCondition Path=`"$Path`" /></Conditions></FilePathRule>"
}
$rules = @(
    (New-Rule 'Administrators may run all applications' $admins '*'),
    (New-Rule 'MoviePC Windows components' $sid '%WINDIR%\*'),
    (New-Rule 'MoviePC Mode applications' $sid "$InstallRoot\*"),
    (New-Rule 'Brave 64-bit' $sid '%PROGRAMFILES%\BraveSoftware\Brave-Browser\Application\*'),
    (New-Rule 'Brave 32-bit' $sid '%PROGRAMFILES(x86)%\BraveSoftware\Brave-Browser\Application\*'),
    (New-Rule 'Private MoviePC VLC' $sid "$InstallRoot\Apps\VLC\*")
) -join "`r`n"
$xml = "<AppLockerPolicy Version=`"1`">`r`n  <RuleCollection Type=`"Exe`" EnforcementMode=`"AuditOnly`">`r`n$rules`r`n  </RuleCollection>`r`n</AppLockerPolicy>"
$folder = Join-Path $ProgramDataRoot 'AppLocker'
New-Item -ItemType Directory -Path $folder -Force | Out-Null
$backup = Join-Path $folder 'Before-MoviePC-Mode.xml'
if (-not (Test-Path $backup)) { Get-AppLockerPolicy -Local -Xml | Set-Content $backup -Encoding UTF8 }
$policy = Join-Path $folder 'MoviePC-AuditOnly.xml'
Set-Content $policy $xml -Encoding UTF8
Set-AppLockerPolicy -XmlPolicy $policy
Write-Host 'AuditOnly mode enabled. Nothing is blocked yet. Use the MoviePC account normally before enforcing.'
