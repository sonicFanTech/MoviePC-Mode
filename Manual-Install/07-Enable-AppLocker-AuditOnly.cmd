@echo off
setlocal
cd /d "%~dp0"
net session >nul 2>&1 || (echo ERROR: Run as Administrator.& pause & exit /b 1)
echo This is AuditOnly mode. It records events but should not block apps.
powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%~dp0Scripts\07-Enable-AppLocker-AuditOnly.ps1"
pause
