@echo off
setlocal
cd /d "%~dp0"
net session >nul 2>&1 || (echo ERROR: Run as Administrator.& pause & exit /b 1)
call "08-Emergency-Restore-Explorer.cmd"
echo Removing MoviePC Mode files...
rmdir /s /q "%ProgramFiles%\MoviePC Mode"
reg delete "HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall\MoviePC Mode" /f 2>nul
echo.
echo Files removed. The MoviePC user account was preserved.
echo To remove the account and its profile manually, run:
echo   net user "MoviePC" /delete
pause
