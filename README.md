# MoviePC Mode

MoviePC Mode is a closed-source Windows desktop replacement designed for a dedicated movie and television computer. It creates a restricted local `MoviePC` account with a lightweight custom desktop, a media-focused taskbar, a separate restricted File Explorer, and a custom Settings app. Administrator accounts continue to use the normal Windows Explorer desktop for maintenance and recovery.

> **Distribution model:** MoviePC Mode is freeware, but it is **not open source** and its source code is not distributed publicly. Public releases should contain compiled installers, documentation, and optional manual-deployment scripts only.

## What MoviePC Mode is for

A normal Windows desktop exposes far more controls than a living-room media computer needs. A guest could open Settings, browse system folders, run unrelated programs, or change something that breaks the setup. MoviePC Mode provides a simpler media-first desktop without replacing Windows itself.

It is suitable for:

- A dedicated computer connected to a television.
- A small movie computer used by family members or guests.
- A laptop repurposed as a portable media machine.
- A desktop computer used as a restricted home-theater PC.

MoviePC Settings detects whether Windows reports a battery and labels the device as a portable or desktop computer accordingly.

## Included applications

MoviePC Mode installs four native Windows applications:

| Component | Version | Build | Purpose |
|---|---:|---:|---|
| MoviePC Shell | 1.1.0 | 1100 | Custom wallpaper desktop, taskbar, Start menu, Wi-Fi and volume flyouts, desktop shortcuts, and app switching |
| MoviePC File Explorer | 1.1.1 | 1101 | Restricted video-file browser with Libraries and This PC views |
| MoviePC Settings | 1.1.2 | 1102 | Windows-Settings-style control panel for safe MoviePC settings |
| MoviePC Mode Installer / Maintenance Tool | 1.1.3 | 1103 | Installation, repair, uninstall, recovery, logging, and optional AppLocker hardening |

## Main desktop experience

### Custom shell

The MoviePC Shell replaces `explorer.exe` only for the standard local `MoviePC` account. Administrator accounts keep the normal Windows desktop.

The shell provides:

- The current Windows wallpaper.
- A Windows-style taskbar.
- A modernized Windows 7-style Start menu.
- The current account name and picture.
- Running-application taskbar icons.
- Wi-Fi management for known profiles.
- Real Windows master-volume control.
- Clock and date.
- Shutdown, restart, and sign-out actions.
- Custom `Alt+Tab` and `Win+Tab` app switching.
- Windows-key Start-menu control.

When an ordinary application opens, MoviePC Shell now keeps a dedicated wallpaper backdrop visible rather than leaving a black background behind the app window. Maximized windows use the reserved work area above the MoviePC taskbar. When an app enters true fullscreen mode, the custom taskbar hides until fullscreen ends.

### Media-only desktop shortcuts

MoviePC Shell reads real `.lnk` and `.url` shortcuts from the current user and Public desktop folders. For additional lock-down, it only displays media-related shortcuts, such as MoviePC tools, Brave, VLC, Plex, Kodi, and supported streaming shortcuts.

Visible shortcuts can be moved around the desktop and resized. Their layout is stored per Windows account.

## Restricted MoviePC File Explorer

`MoviePCFileExplorer.exe` is a separate native application with a normal Windows File Explorer-style layout.

It includes:

- Libraries navigation.
- This PC navigation.
- A read-only address bar.
- Back, Up, Refresh, and This PC controls.
- Details view and large-icon view.
- Light and dark themes.
- Right-click menus.
- VLC playback integration.

### Storage restrictions

- `C:` remains visible under **This PC**, but direct browsing is blocked.
- Approved libraries on `C:` remain available.
- Secondary disks, USB drives, and optical drives can be explored.
- Folders remain visible so the user can navigate to media.
- Non-video files remain hidden.
- Supported video files can be opened in the private MoviePC VLC copy.

## MoviePC Settings

`MoviePCSettings.exe` has a custom Windows 10 Settings-inspired interface rather than a basic Win32 button layout.

It includes:

- Embedded multi-size icons.
- Category pages and left navigation.
- Light, dark, and follow-Windows themes.
- Search suggestions while typing.
- A **Show all results** page.
- Real dropdown menus for multi-choice settings.
- Real Windows information on the About page.

### Safe real settings

The MoviePC account can change everyday settings such as:

- Display resolution, refresh rate, orientation, and compatible built-in-display brightness.
- Master volume and mute.
- Screen-off and sleep timeouts.
- Known Wi-Fi connections.
- Wallpaper and wallpaper fit.
- Windows light or dark theme preference.
- MoviePC taskbar size, transparency, clock, date, and icon-label options.
- MoviePC File Explorer startup page, view mode, navigation pane, toolbar, status bar, address bar, and filename-extension visibility.

### Administrator-only settings

Riskier changes remain outside MoviePC Mode, including:

- Advanced monitor arrangement.
- HDR and color-management changes.
- Custom DPI scaling.
- New Windows accounts.
- New secured Wi-Fi profiles.
- Windows Update installation and forced restarts.
- Driver control panels.
- Deep system troubleshooting.

The Windows Update page can perform a real scan but does not automatically install updates.

## Brave Browser restrictions

MoviePC Mode installs or detects Brave Browser and launches it with a dedicated MoviePC browser profile.

For the `MoviePC` account, the installer applies Chromium-compatible Brave policies:

- Block all websites by default.
- Allow an approved list of legitimate streaming and media services.
- Disable guest profiles.
- Disable adding browser profiles.
- Disable Incognito mode.
- Disable developer tools.
- Disable password-manager onboarding.
- Restrict downloads.

The default allowlist includes services such as Netflix, Hulu, Disney+, Max, Prime Video, Paramount+, Peacock, Tubi, Pluto TV, Roku, Plex, Crunchyroll, YouTube, and IMDb.

Streaming services often use extra authentication, DRM, CDN, or asset domains. An administrator may need to add a required domain after testing a legitimate service. The manual deployment folder includes:

```text
10-Add-Brave-Allowed-Domain.cmd
11-Restore-Default-Brave-Streaming-Allowlist.cmd
```

## Brave and VLC preparation

The one-click installer prepares the media applications automatically:

- Brave Browser is downloaded from Brave's official Windows download endpoint when it is not already installed.
- MoviePC Mode uses a dedicated Brave profile under the MoviePC account.
- VLC is downloaded from VideoLAN's official Windows archive and extracted privately under:

```text
C:\Program Files\MoviePC Mode\Apps\VLC
```

The private VLC copy is intended for MoviePC Mode rather than general system use.

## Windows requirements

MoviePC Mode requires a Windows edition that supports Shell Launcher, such as:

- Windows Enterprise
- Windows Enterprise LTSC
- Windows Education
- Windows IoT Enterprise
- Windows IoT Enterprise LTSC

An administrator account must remain available for maintenance and emergency recovery.

## One-click installation

Run:

```text
Install-MoviePC-Mode.exe
```

The native installer:

1. Installs the MoviePC programs.
2. Downloads or detects Brave.
3. Downloads and extracts the private MoviePC VLC copy.
4. Creates or reuses the passwordless local `MoviePC` standard account.
5. Enables the Shell Launcher optional Windows feature.
6. Assigns MoviePC Shell only to the MoviePC account.
7. Applies the account restrictions and Brave allowlist.
8. Installs maintenance, recovery, and uninstall shortcuts.
9. Registers MoviePC Mode in Installed Apps.
10. Saves a full setup transcript.

If Windows needs a restart after enabling Shell Launcher, restart, sign into the administrator account, and run the installer again.

Setup logs are saved under:

```text
C:\ProgramData\MoviePC Mode\Logs
```

## Manual installation

A public release may also include the `Manual-Installation` folder for administrators who want to run each deployment stage separately.

Start with:

```text
Manual-Installation\README-MANUAL-INSTALL.md
```

The folder contains individual scripts for payload installation, account creation, Shell Launcher configuration, Brave policies, AppLocker audit mode, AppLocker enforcement, audit reporting, emergency recovery, and uninstall.

The scripts are optional. Most users should use the one-click installer.

## AppLocker hardening

MoviePC Mode includes optional AppLocker support. It intentionally starts with **AuditOnly** mode.

Recommended process:

1. Enable AuditOnly mode from MoviePC Mode Maintenance.
2. Sign into the MoviePC account.
3. Test Brave, VLC, DVD playback, USB video playback, File Explorer, Settings, Wi-Fi, and volume controls.
4. Generate the AppLocker audit report.
5. Review legitimate helper programs.
6. Enforce the allow-list only after the report is clean.

Administrator accounts remain excluded from MoviePC restrictions for recovery.

## Emergency recovery

From an administrator account, open:

```text
MoviePC Mode Maintenance
```

Then select:

```text
Emergency Restore Explorer
```

That removes the custom-shell assignment, restores `explorer.exe`, removes the MoviePC account policies, and attempts to restore the previous AppLocker policy.

The manual deployment folder also includes:

```text
08-Emergency-Restore-Explorer.cmd
```

Keep a copy of the installer and manual recovery folder on a USB drive while testing.

## Uninstallation

Use either:

```text
Settings > Apps > MoviePC Mode > Uninstall
```

or the installed MoviePC Mode maintenance shortcut.

The native uninstaller can optionally preserve or delete the local `MoviePC` account.

## Closed-source notice

MoviePC Mode is closed-source freeware created by **sonic Fan Tech**.

Public releases may distribute the compiled installer and documentation. The source code is not included, published, or licensed for redistribution.

Third-party programs downloaded by MoviePC Mode remain subject to their own licenses and terms, including Brave Browser and VLC media player.

## Status

MoviePC Mode is still undergoing real-device testing. Test new builds on a non-critical media computer while keeping an administrator recovery account available.
