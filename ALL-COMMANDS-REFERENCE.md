# MoviePC Mode Manual Command Reference

This file lists the main administrative commands used by the manual deployment toolkit. Run them only from a separate administrator account.

## Enable Shell Launcher

```bat
dism.exe /Online /Enable-Feature /All /FeatureName:Client-EmbeddedShellLauncher /NoRestart
```

After any required restart, configure the per-user shell from an elevated PowerShell window:

```powershell
$sid = ([System.Security.Principal.NTAccount]'MoviePC').Translate([System.Security.Principal.SecurityIdentifier]).Value
$class = [wmiclass]'\\localhost\root\standardcimv2\embedded:WESL_UserSetting'
$exe = "$env:ProgramFiles\MoviePC Mode\MoviePCShell.exe"
$cmd = '"' + $exe + '" --shell-mode'
$null = $class.SetDefaultShell('explorer.exe', 0)
$null = $class.SetCustomShell($sid, $cmd, $null, $null, 0)
$null = $class.SetEnabled($true)
```

## Restore Explorer immediately

```powershell
$sid = ([System.Security.Principal.NTAccount]'MoviePC').Translate([System.Security.Principal.SecurityIdentifier]).Value
$class = [wmiclass]'\\localhost\root\standardcimv2\embedded:WESL_UserSetting'
$null = $class.RemoveCustomShell($sid)
$null = $class.SetDefaultShell('explorer.exe', 0)
$null = $class.SetEnabled($false)
```

## Create the standard account

```bat
net user "MoviePC" "" /add /passwordchg:no /expires:never
net localgroup "Users" "MoviePC" /add
net localgroup "Administrators" "MoviePC" /delete
```

## Brave navigation restriction

The full implementation is in `Scripts\05-Apply-Brave-Media-Allowlist.ps1`. It writes policy values under the MoviePC account's loaded registry hive:

```text
Software\Policies\BraveSoftware\Brave
Software\Policies\BraveSoftware\Brave\URLBlocklist
Software\Policies\BraveSoftware\Brave\URLAllowlist
```

The block list contains `*`. The allow list is populated from:

```text
C:\Program Files\MoviePC Mode\AllowedStreamingSites.txt
```

Add only services that the administrator is authorized to use.

## AppLocker

Apply AuditOnly mode first. The complete example is in `Scripts\07-Enable-AppLocker-AuditOnly.ps1`.

## Logs

The one-click native installer writes command transcripts under:

```text
C:\ProgramData\MoviePC Mode\Logs
```
