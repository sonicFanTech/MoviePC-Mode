@echo off
setlocal
"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -ExecutionPolicy Bypass -File "%~dp004-Apply-MoviePC-Policies-and-Brave-Allowlist.ps1"
pause
