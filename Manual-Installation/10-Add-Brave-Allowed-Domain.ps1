param([Parameter(Mandatory=$true)][string]$Pattern)
. "$PSScriptRoot\Common.ps1"
Assert-Administrator
Write-Step 'Add an administrator-approved Brave URLAllowlist entry'
Invoke-WithUserHive {
    param($root)
    $allow = Ensure-Key (Join-Path $root 'Software\Policies\BraveSoftware\Brave\URLAllowlist')
    $existing = Get-ItemProperty $allow
    $numbers = $existing.PSObject.Properties.Name | Where-Object { $_ -match '^\d+$' } | ForEach-Object {[int]$_}
    $next = if ($numbers) { (($numbers | Measure-Object -Maximum).Maximum + 1) } else { 1 }
    New-ItemProperty $allow ([string]$next) -PropertyType String -Value $Pattern -Force | Out-Null
    Write-Host "Added URLAllowlist[$next] = $Pattern"
}
Write-Host 'Close and reopen Brave from MoviePC Mode to apply the change.'
