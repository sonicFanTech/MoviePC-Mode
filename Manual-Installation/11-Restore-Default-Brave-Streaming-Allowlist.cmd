@echo off
setlocal
"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -ExecutionPolicy Bypass -File "%~dp011-Restore-Default-Brave-Streaming-Allowlist.ps1"
pause
