@echo off
setlocal
cd /d "%~dp0"
net session >nul 2>&1 || (echo ERROR: Run as Administrator.& pause & exit /b 1)
powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%~dp0Scripts\06-Install-Brave-and-VLC.ps1"
pause
