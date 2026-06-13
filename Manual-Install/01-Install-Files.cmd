@echo off
setlocal
cd /d "%~dp0"
net session >nul 2>&1 || (echo ERROR: Run as Administrator.& pause & exit /b 1)
set "DEST=%ProgramFiles%\MoviePC Mode"
echo Creating "%DEST%"...
mkdir "%DEST%" 2>nul
copy /y "..\Developer-Binaries\MoviePCShell.exe" "%DEST%\MoviePCShell.exe"
copy /y "..\Developer-Binaries\MoviePCFileExplorer.exe" "%DEST%\MoviePCFileExplorer.exe"
copy /y "..\Developer-Binaries\MoviePCSettings.exe" "%DEST%\MoviePCSettings.exe"
copy /y "..\Developer-Binaries\MoviePCShell.ini" "%DEST%\MoviePCShell.ini"
copy /y "..\Developer-Binaries\AllowedStreamingSites.txt" "%DEST%\AllowedStreamingSites.txt"
echo.
echo Installed core files to "%DEST%".
pause
