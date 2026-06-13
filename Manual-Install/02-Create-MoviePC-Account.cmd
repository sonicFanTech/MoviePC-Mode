@echo off
setlocal
net session >nul 2>&1 || (echo ERROR: Run as Administrator.& pause & exit /b 1)
echo Creating or updating the passwordless MoviePC standard account...
net user "MoviePC" "" /add /passwordchg:no /expires:never
net localgroup "Users" "MoviePC" /add
net localgroup "Administrators" "MoviePC" /delete
echo.
echo IMPORTANT: Sign out, sign into MoviePC once, then sign back into your
 echo administrator account before continuing. This creates the MoviePC profile.
pause
