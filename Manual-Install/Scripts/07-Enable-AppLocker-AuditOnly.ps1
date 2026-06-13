$ErrorActionPreference = 'Stop'
if (!(Get-Command Set-AppLockerPolicy -ErrorAction SilentlyContinue)) { throw 'AppLocker cmdlets are unavailable on this Windows edition.' }
$sid = ([System.Security.Principal.NTAccount]'MoviePC').Translate([System.Security.Principal.SecurityIdentifier]).Value
$dir = Join-Path $env:ProgramData 'MoviePC Mode\AppLocker'
New-Item -ItemType Directory -Path $dir -Force | Out-Null
$backup = Join-Path $dir 'Before-MoviePC-Mode.xml'
if (!(Test-Path $backup)) { Get-AppLockerPolicy -Local -Xml | Set-Content -LiteralPath $backup -Encoding UTF8 }
$policy = Join-Path $dir 'Manual-AuditOnly.xml'
$xml = @"
<AppLockerPolicy Version="1">
  <RuleCollection Type="Exe" EnforcementMode="AuditOnly">
    <FilePathRule Id="{11111111-1111-1111-1111-111111111111}" Name="Administrators may run all applications" Description="Recovery" UserOrGroupSid="S-1-5-32-544" Action="Allow"><Conditions><FilePathCondition Path="*" /></Conditions></FilePathRule>
    <FilePathRule Id="{22222222-2222-2222-2222-222222222222}" Name="MoviePC Windows components" Description="Windows" UserOrGroupSid="$sid" Action="Allow"><Conditions><FilePathCondition Path="%WINDIR%\*" /></Conditions></FilePathRule>
    <FilePathRule Id="{33333333-3333-3333-3333-333333333333}" Name="MoviePC Mode applications" Description="MoviePC" UserOrGroupSid="$sid" Action="Allow"><Conditions><FilePathCondition Path="%PROGRAMFILES%\MoviePC Mode\*" /></Conditions></FilePathRule>
    <FilePathRule Id="{44444444-4444-4444-4444-444444444444}" Name="Brave" Description="Browser" UserOrGroupSid="$sid" Action="Allow"><Conditions><FilePathCondition Path="%PROGRAMFILES%\BraveSoftware\Brave-Browser\Application\*" /></Conditions></FilePathRule>
  </RuleCollection>
</AppLockerPolicy>
"@
$xml | Set-Content -LiteralPath $policy -Encoding UTF8
& sc.exe config AppIDSvc start= auto | Out-Null
try { Start-Service AppIDSvc -ErrorAction Stop } catch {}
Set-AppLockerPolicy -XmlPolicy $policy
Write-Host 'AppLocker AuditOnly policy applied.'
