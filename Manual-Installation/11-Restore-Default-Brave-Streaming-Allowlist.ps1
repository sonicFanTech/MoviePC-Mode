. "$PSScriptRoot\Common.ps1"
Assert-Administrator
Write-Step 'Restore default Brave streaming allowlist'
Invoke-WithUserHive { param($root) Apply-Brave-Allowlist $root }
Write-Host 'Default Brave streaming allowlist restored.'
