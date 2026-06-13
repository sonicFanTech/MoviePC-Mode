@echo off
setlocal
set /p "PATTERN=Enter Chromium URLAllowlist pattern, for example *://*.example.com/* : "
"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -ExecutionPolicy Bypass -File "%~dp010-Add-Brave-Allowed-Domain.ps1" -Pattern "%PATTERN%"
pause
