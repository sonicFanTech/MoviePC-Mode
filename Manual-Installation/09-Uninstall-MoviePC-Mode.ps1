. "$PSScriptRoot\Common.ps1"
Assert-Administrator
Write-Step 'Restore Explorer before uninstalling'
& "$PSScriptRoot\08-Emergency-Restore-Explorer.ps1"
Write-Step 'Remove MoviePC Mode files'
Remove-Item $InstallRoot -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\MoviePC Mode' -Recurse -Force -ErrorAction SilentlyContinue
$removeAccount = Read-Host 'Delete the local MoviePC account too? Type DELETE to remove it'
if ($removeAccount -eq 'DELETE') { & net.exe user $MovieAccount /delete | Out-Host }
Write-Host 'Manual uninstall complete. Restart Windows.'
