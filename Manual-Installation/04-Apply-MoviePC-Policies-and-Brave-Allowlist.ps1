. "$PSScriptRoot\Common.ps1"
Assert-Administrator
Write-Step 'Apply restricted MoviePC account policies and Brave streaming allowlist'
Invoke-WithUserHive {
    param($root)
    New-ItemProperty (Ensure-Key (Join-Path $root 'Software\Microsoft\Windows\CurrentVersion\Policies\Explorer')) NoControlPanel -PropertyType DWord -Value 1 -Force | Out-Null
    New-ItemProperty (Ensure-Key (Join-Path $root 'Software\Microsoft\Windows\CurrentVersion\Policies\Explorer')) NoRun -PropertyType DWord -Value 1 -Force | Out-Null
    New-ItemProperty (Ensure-Key (Join-Path $root 'Software\Microsoft\Windows\CurrentVersion\Policies\System')) DisableTaskMgr -PropertyType DWord -Value 1 -Force | Out-Null
    New-ItemProperty (Ensure-Key (Join-Path $root 'Software\Microsoft\Windows\CurrentVersion\Policies\System')) DisableRegistryTools -PropertyType DWord -Value 1 -Force | Out-Null
    New-ItemProperty (Ensure-Key (Join-Path $root 'Software\Policies\Microsoft\Windows\System')) DisableCMD -PropertyType DWord -Value 1 -Force | Out-Null
    Apply-Brave-Allowlist $root
}
Write-Host 'MoviePC policies applied. Test legitimate streaming services and add required service domains with 10-Add-Brave-Allowed-Domain.ps1.'
