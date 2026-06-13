@echo off
setlocal
cd /d "%~dp0"
echo ============================================================
echo MoviePC Mode - Manual Deployment Requirements Check
echo ============================================================
echo.
net session >nul 2>&1
if errorlevel 1 (
  echo ERROR: Run this script as Administrator.
  pause
  exit /b 1
)
echo [OK] Administrator privileges detected.
if exist "..\Developer-Binaries\MoviePCShell.exe" (echo [OK] MoviePCShell.exe found.) else echo [MISSING] ..\Developer-Binaries\MoviePCShell.exe
if exist "..\Developer-Binaries\MoviePCFileExplorer.exe" (echo [OK] MoviePCFileExplorer.exe found.) else echo [MISSING] ..\Developer-Binaries\MoviePCFileExplorer.exe
if exist "..\Developer-Binaries\MoviePCSettings.exe" (echo [OK] MoviePCSettings.exe found.) else echo [MISSING] ..\Developer-Binaries\MoviePCSettings.exe
if exist "..\Developer-Binaries\AllowedStreamingSites.txt" (echo [OK] AllowedStreamingSites.txt found.) else echo [MISSING] ..\Developer-Binaries\AllowedStreamingSites.txt
echo.
echo Windows edition:
wmic os get Caption,Version /value 2>nul
if errorlevel 1 powershell.exe -NoProfile -Command "Get-CimInstance Win32_OperatingSystem ^| Select-Object Caption,Version ^| Format-List"
echo.
echo Shell Launcher feature state:
dism.exe /Online /Get-FeatureInfo /FeatureName:Client-EmbeddedShellLauncher
echo.
echo Review the output above before continuing.
pause
