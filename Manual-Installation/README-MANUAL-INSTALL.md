# MoviePC Mode manual installation

The one-click native installer is recommended for normal users. These scripts are provided for administrators who want to inspect and run each deployment stage separately.

## Before starting

- Use a supported Windows Enterprise, Education, or IoT Enterprise edition.
- Keep a working administrator account.
- Build MoviePC Mode first so this folder contains `Payload\MoviePCShell.exe`, `Payload\MoviePCFileExplorer.exe`, `Payload\MoviePCSettings.exe`, and `Payload\MoviePCShell.ini`.
- Copy this entire folder to a USB drive before applying Shell Launcher or AppLocker rules.
- Run scripts from an elevated administrator account.

## Recommended sequence

Run these `.cmd` wrappers in order:

```text
01-Install-Payload-and-Media-Apps.cmd
02-Create-MoviePC-Account.cmd
03-Enable-Shell-Launcher.cmd
04-Apply-MoviePC-Policies-and-Brave-Allowlist.cmd
05-Enable-AppLocker-AuditOnly.cmd
```

After script 02, sign into `MoviePC` once if Windows has not created its profile, then return to the administrator account.

After script 03, restart Windows if DISM says a restart is required, then rerun script 03.

Use the MoviePC account normally before enforcing AppLocker. Then run:

```text
06-Generate-AppLocker-Audit-Report.cmd
```

Review the report carefully. Only then run:

```text
07-Enforce-AppLocker-AllowList.cmd
```

## Streaming-domain maintenance

MoviePC Mode blocks arbitrary websites in Brave and allows approved streaming domains. Some legitimate services use additional CDN, authentication, DRM, or asset domains.

To add an administrator-approved URL pattern:

```text
10-Add-Brave-Allowed-Domain.cmd
```

To restore the default list:

```text
11-Restore-Default-Brave-Streaming-Allowlist.cmd
```

## Recovery

Keep this file available from an administrator account:

```text
08-Emergency-Restore-Explorer.cmd
```

It removes the custom MoviePC shell assignment, restores Explorer, removes MoviePC account policies, and restores the previous AppLocker policy when a backup exists.

## Manual uninstall

Run:

```text
09-Uninstall-MoviePC-Mode.cmd
```

## Commands reference

See:

```text
ALL-COMMANDS-REFERENCE.md
```
