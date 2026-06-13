@echo off
setlocal
cd /d "%~dp0"
net session >nul 2>&1 || (echo ERROR: Run as Administrator.& pause & exit /b 1)
echo Enabling Windows Shell Launcher...
dism.exe /Online /Enable-Feature /All /FeatureName:Client-EmbeddedShellLauncher /NoRestart
if errorlevel 1 (echo ERROR: DISM failed.& pause & exit /b 1)
echo.
echo If DISM says that a restart is required, restart Windows before running
 echo this script again. Otherwise, press a key to assign the custom shell.
pause
powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%~dp0Scripts\03-Enable-Shell-Launcher.ps1"
pause
