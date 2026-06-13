. "$PSScriptRoot\Common.ps1"
Assert-Administrator
Write-Step 'Create or repair local MoviePC standard account'
if (-not (Get-LocalUser -Name $MovieAccount -ErrorAction SilentlyContinue)) {
    & net.exe user $MovieAccount '' /add /comment:'Restricted standard account used by MoviePC Mode' /passwordchg:no | Out-Host
    if ($LASTEXITCODE -ne 0) { throw 'net user failed to create MoviePC.' }
}
& net.exe user $MovieAccount '' | Out-Host
& net.exe localgroup Users $MovieAccount /add | Out-Host
& net.exe localgroup Administrators $MovieAccount /delete | Out-Host
Write-Host 'MoviePC exists as a passwordless standard account.'
Write-Host 'Sign into MoviePC once if Windows has not created its user profile yet, then return to the administrator account.'
