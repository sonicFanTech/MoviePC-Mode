# MoviePC Mode Manual Deployment Toolkit

Use the one-click native installer whenever possible. These scripts exist for administrators who want to inspect and run each deployment step manually.

## Important safety rules

1. Run the scripts from a separate administrator account, not from `MoviePC`.
2. Keep a copy of `08-Emergency-Restore-Explorer.cmd` on a USB drive before assigning the custom shell.
3. Keep at least one working administrator account on the computer.
4. After creating the MoviePC account, sign into it once and then sign back into the administrator account before applying per-user registry restrictions. This creates the user profile hive cleanly.
5. Start AppLocker in **AuditOnly** mode. Review the audit events before enforcing anything.
6. Add only legitimate streaming services that you are authorized to use to `AllowedStreamingSites.txt`.

## Recommended order

```text
00-Check-Requirements.cmd
01-Install-Files.cmd
02-Create-MoviePC-Account.cmd
03-Enable-Shell-Launcher.cmd
04-Apply-Account-Restrictions.cmd
05-Apply-Brave-Media-Allowlist.cmd
06-Install-Brave-and-VLC.cmd
07-Enable-AppLocker-AuditOnly.cmd
```

To undo the custom shell and policies:

```text
08-Emergency-Restore-Explorer.cmd
```

To remove the installed files after recovery:

```text
09-Uninstall-MoviePC-Mode.cmd
```

The scripts intentionally pause and show their commands. Read each `.cmd` and `.ps1` file before running it.
