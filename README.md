# MoviePC Mode

**MoviePC Mode** is a closed-source Windows media-shell environment designed for dedicated movie and TV playback computers. It replaces the normal Explorer desktop for a separate standard Windows account with a lightweight custom desktop, a restricted media-oriented File Explorer, and a custom Settings app.

The project is intended for devices that should remain simple and difficult for guests to misconfigure: a living-room PC, a spare laptop connected to a television, a guest-room computer, or a portable movie machine.

> **Source availability:** MoviePC Mode is freeware, but it is **not open source** and is **not source available**.

## Screenshots

Add screenshots here after creating the public release page:

- Custom MoviePC desktop and taskbar
- Start menu
- MoviePC File Explorer
- MoviePC Settings
- Native installer wizard

## Main features

### Custom desktop shell

MoviePC Shell replaces the Explorer desktop only for the separate `MoviePC` standard account. An administrator account keeps the normal Windows desktop for maintenance and emergency recovery.

The shell includes:

- The current Windows wallpaper
- Movable and resizable approved desktop shortcuts
- A custom taskbar with running-app buttons
- Start menu with account picture and power controls
- Volume control
- Wi-Fi management
- Clock and date
- Custom Windows-key Start-menu behavior
- Custom Alt+Tab and Win+Tab app switcher
- Appbar-based work-area reservation so maximized windows stop above the taskbar
- Automatic taskbar suppression for true full-screen playback

Desktop icons are filtered. MoviePC Mode shows only approved media applications, MoviePC components, and allow-listed media-site shortcuts rather than every shortcut from the public desktop.

### Restricted MoviePC File Explorer

`MoviePCFileExplorer.exe` is a separate native application with a familiar Windows-style layout. It includes Libraries, This PC, navigation controls, an address bar, a file list, and context menus.

Restrictions are intentional:

- The `C:` drive appears under **This PC** but cannot be browsed directly.
- Approved libraries on `C:` remain available.
- USB drives, optical drives, and secondary drives can be browsed.
- Folders remain available for navigation.
- Non-video files remain hidden.
- Supported video files can be opened in VLC.
- The app follows the selected light or dark MoviePC theme.

### Custom MoviePC Settings

`MoviePCSettings.exe` provides a Windows-Settings-inspired interface with real, carefully selected controls. Everyday media-device settings are exposed, while advanced or risky maintenance options remain administrator-only.

Included pages cover:

- Display resolution, refresh rate, orientation, scaling information, display detection, and supported brightness controls
- Master volume and mute
- Notifications
- Power and sleep timing
- Storage reporting
- Wi-Fi and network status
- Bluetooth and printers
- Wallpaper and theme controls
- MoviePC desktop appearance
- MoviePC File Explorer appearance
- Ease-of-access animation preferences
- Windows Update scan status without automatic installation
- Computer information, hardware specifications, OS build, detected device type, and MoviePC component versions

The app automatically distinguishes between a laptop and a desktop computer when Windows reports a usable battery.

## Restricted Brave profile

MoviePC Mode opens Brave with a dedicated MoviePC profile and applies Chromium-compatible Brave policies to the `MoviePC` account.

The default policy blocks ordinary web navigation and allows only domains listed in:

```text
C:\Program Files\MoviePC Mode\AllowedStreamingSites.txt
```

The default list contains legitimate media and streaming services such as YouTube, Netflix, Hulu, Disney+, Max, Prime Video, Paramount+, Peacock, Tubi, Pluto TV, Plex, Crunchyroll, Kanopy, Hoopla, Fandango at Home, Apple TV, and the Roku Channel.

An administrator may edit the list when an authorized service requires an additional sign-in or playback domain. MoviePC Mode does **not** bypass subscriptions, DRM, regional restrictions, or a streaming provider's terms of use. Do not add unauthorized streaming sites.

Brave is Chromium-based and supports Chromium policies. Brave documents Windows policy deployment through the registry under its Brave policy path. See the official Brave Group Policy documentation:

```text
https://support.brave.com/hc/en-us/articles/360039248271-Group-Policy
```

### Brave installation note

The one-click installer can download or reuse Brave Browser. Brave's official Windows browser installation is machine-wide when the installer selects system-level installation. MoviePC Mode keeps browsing separated through a dedicated restricted MoviePC profile and per-account policy configuration.

## VLC deployment

The installer can download the official VideoLAN VLC ZIP and copy a private MoviePC VLC installation under:

```text
C:\Program Files\MoviePC Mode\Apps\VLC
```

The MoviePC shell and File Explorer prefer this private VLC copy when it exists.

Official VLC Windows downloads:

```text
https://www.videolan.org/vlc/download-windows.html
```

## Supported Windows editions

MoviePC Mode uses Microsoft's Shell Launcher feature. Shell Launcher is available on supported Windows Enterprise, Education, and IoT Enterprise editions, including relevant LTSC editions. A standard Home or Pro installation may not provide the required feature.

Microsoft Shell Launcher documentation:

```text
https://learn.microsoft.com/windows/configuration/shell-launcher/
```

## Installation

### One-click installer

Download and run:

```text
Install-MoviePC-Mode.exe
```

The native setup wizard:

1. Installs MoviePC Shell, File Explorer, Settings, and the editable streaming-site list.
2. Creates or reuses a passwordless local standard account named `MoviePC` when the recommended option remains enabled.
3. Optionally downloads or reuses Brave Browser.
4. Optionally downloads a private MoviePC VLC copy.
5. Enables the Windows Shell Launcher optional feature.
6. Assigns MoviePC Shell only to the `MoviePC` account.
7. Applies account-level restrictions.
8. Applies Brave media-site restrictions.
9. Creates maintenance, recovery, and uninstall shortcuts.
10. Optionally enables AppLocker in **AuditOnly** mode.

The installer shows a live command transcript and writes permanent logs under:

```text
C:\ProgramData\MoviePC Mode\Logs
```

If Windows reports that enabling Shell Launcher requires a restart, restart into the administrator account and run the installer again.

### Manual deployment toolkit

For administrators who prefer to inspect every command, the release package also contains:

```text
Manual-Install\
```

Start with:

```text
Manual-Install\README-FIRST.md
```

The toolkit contains separate scripts for requirements checking, file installation, account creation, Shell Launcher configuration, account policies, Brave allow-list policy, Brave/VLC provisioning, AppLocker AuditOnly mode, emergency Explorer recovery, and uninstall cleanup.

A complete command reference is included at:

```text
Manual-Install\ALL-COMMANDS-REFERENCE.md
```

## AppLocker hardening

MoviePC Mode does not immediately enforce AppLocker rules. The safe workflow is:

1. Enable **AuditOnly** mode.
2. Sign into `MoviePC` and test normal movie playback, Brave, VLC, DVDs, Wi-Fi, Settings, and USB browsing.
3. Generate the AppLocker audit report from MoviePC Mode Maintenance.
4. Review legitimate helper processes.
5. Enforce rules only after the audit is clean.

Administrator accounts remain exempt so recovery remains possible.

## Recovery

Keep at least one separate administrator account available at all times.

MoviePC Mode Maintenance includes:

- Emergency Restore Explorer
- Enable AppLocker AuditOnly mode
- Generate AppLocker report
- Enforce AppLocker rules
- Restore previous AppLocker policy
- Uninstall MoviePC Mode

The emergency restore action removes the per-user custom shell assignment and restores:

```text
explorer.exe
```

The manual toolkit also includes:

```text
08-Emergency-Restore-Explorer.cmd
```

Copy that file and its `Scripts` folder to a USB drive before experimenting with enforcement changes.

## Customization files

Per-user appearance preferences are stored here:

```text
%LOCALAPPDATA%\MoviePC Shell\MoviePCUserSettings.ini
```

Shell configuration and the streaming allow list are stored here after installation:

```text
C:\Program Files\MoviePC Mode\MoviePCShell.ini
C:\Program Files\MoviePC Mode\AllowedStreamingSites.txt
```

## Component versions

| Component | Version | Build |
|---|---:|---:|
| MoviePC Shell | 1.1.0 | 1100 |
| MoviePC File Explorer | 1.1.1 | 1101 |
| MoviePC Settings | 1.1.2 | 1102 |
| MoviePC Mode Installer / Maintenance Tool | 1.1.3 | 1103 |

## Privacy and content

MoviePC Mode does not include movies, television episodes, streaming subscriptions, DRM-bypass tools, or unauthorized streaming sources. It provides a restricted Windows interface and launches administrator-approved services.

## License

MoviePC Mode is closed-source freeware. Redistribution, reverse engineering, decompilation, repackaging, bundling, resale, and modification are not permitted unless the copyright holder grants written permission.

## Credits

Created by **sonic Fan Tech**.
