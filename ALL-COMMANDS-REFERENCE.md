.# MoviePC Mode manual commands reference

This file documents the core administrative commands used by MoviePC Mode. The `.cmd` and `.ps1` scripts automate these steps with checks and safer ordering.

## Create a passwordless standard MoviePC account

```bat
net user "MoviePC" "" /add /comment:"Restricted standard account used by MoviePC Mode" /passwordchg:no
net localgroup Users "MoviePC" /add
net localgroup Administrators "MoviePC" /delete
```

## Enable Shell Launcher

```bat
dism.exe /Online /Enable-Feature /All /FeatureName:Client-EmbeddedShellLauncher /NoRestart
```

Restart when DISM returns `3010` or otherwise says a restart is required.

## Configure Shell Launcher from elevated PowerShell

```powershell
$sid = (Get-CimInstance Win32_UserAccount -Filter "LocalAccount=True AND Name='MoviePC'").SID
$class = [wmiclass]'\\localhost\root\standardcimv2\embedded:WESL_UserSetting'
$exe = 'C:\Program Files\MoviePC Mode\MoviePCShell.exe'
$cmd = '"' + $exe + '" --shell-mode'
$null = $class.SetDefaultShell('explorer.exe', 0)
$null = $class.SetCustomShell($sid, $cmd, $null, $null, 0)
$null = $class.SetEnabled($true)
```

## Remove the MoviePC custom shell

```powershell
$sid = (Get-CimInstance Win32_UserAccount -Filter "LocalAccount=True AND Name='MoviePC'").SID
$class = [wmiclass]'\\localhost\root\standardcimv2\embedded:WESL_UserSetting'
try { $null = $class.RemoveCustomShell($sid) } catch {}
try { $null = $class.SetDefaultShell('explorer.exe', 0) } catch {}
try { $null = $class.SetEnabled($false) } catch {}
```

## Download official Brave installer

```powershell
Invoke-WebRequest 'https://laptop-updates.brave.com/latest/winx64' -OutFile '.\BraveBrowserSetup.exe'
Start-Process '.\BraveBrowserSetup.exe' -ArgumentList '--silent --install' -Wait
```

## Download official VLC ZIP archive

```powershell
Invoke-WebRequest 'https://get.videolan.org/vlc/3.0.23/win64/vlc-3.0.23-win64.zip' -OutFile '.\vlc-3.0.23-win64.zip'
Expand-Archive '.\vlc-3.0.23-win64.zip' -DestinationPath '.\VLC-Extract' -Force
```

## Brave site restriction model

The `MoviePC` account receives:

```text
Software\Policies\BraveSoftware\Brave\URLBlocklist\1 = *
```

Approved streaming patterns are added under:

```text
Software\Policies\BraveSoftware\Brave\URLAllowlist
```

Use `10-Add-Brave-Allowed-Domain.cmd` rather than editing the registry by hand.

## AppLocker safe rollout

Use AuditOnly mode first. Do not enforce rules before testing Brave, VLC, Settings, File Explorer, DVD playback, USB playback, and common Windows helper processes.

The provided scripts automate policy XML creation, backup, audit reporting, enforcement, and restore.
