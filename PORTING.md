# Debian 13 Porting Contract

## Source of truth

The upstream project is
[ChrisTitusTech/dwm-titus](https://github.com/ChrisTitusTech/dwm-titus).
The baseline inspected for this port is upstream `main` at commit
`02a590615fe2d7537d02d96a932d7163e15d4700` (2026-11-05).

The Debian port must retain the upstream patched dwm source and existing
configuration. Do not substitute vanilla suckless dwm, recreate the keymap,
or simplify the window manager feature set.

## Compatibility principles

1. Preserve existing user-visible behavior unless a Fedora-only integration
   cannot operate on Debian.
2. Make the smallest platform-specific change that enables Debian support.
3. Keep Debian changes isolated in this repository; never modify upstream.
4. Preserve user configuration and existing XFCE4 installation.
5. Do not switch display managers. LightDM remains the greeter and login
   manager.
6. Do not remove or overwrite the XFCE4 session.
7. The dwm-titus session is an additional Xorg session selectable from LightDM.
8. No Quickshell dependency or Quickshell process in the Debian session.
9. Replace the Quickshell panel with the native dwm bar, retaining the existing
   status and interaction requirements as closely as the native bar allows.
10. Do not claim runtime support until it is tested in the Debian 13 VM.

## Platform contract

| Area | Debian target |
| --- | --- |
| Distribution | Debian 13 Trixie |
| Architecture | amd64 |
| Existing desktop | XFCE4 remains installed |
| Display manager | LightDM remains installed and enabled |
| Display server | Xorg |
| Window manager | Upstream patched dwm-titus |
| Panel | Native dwm bar |
| Quickshell | Not installed or started |
| Login sessions | XFCE4 and dwm-titus both selectable |

## Change boundaries

### Preserve

- `dwm.c`, `drw.c`, `util.c`, TOML parser and upstream patches
- `config.def.h` and the existing compile-time configuration model
- Runtime TOML settings, keybindings, layouts, tags, window rules and themes
- Existing helper commands and settings behavior where their dependencies exist
- Existing user files and XDG configuration paths

### Adapt only where required

- Fedora package manager and package names
- RPM packaging and Fedora-only repository/image integration
- System paths and executable locations where Debian differs
- Session installation and startup integration for LightDM/Xorg
- Quickshell panel/runtime integration, replaced by native dwm bar components
- Optional Fedora-specific utilities with Debian equivalents or graceful
  feature detection

### Explicitly out of scope

- Replacing XFCE4
- Installing or enabling GDM
- Replacing LightDM
- A Wayland-native session
- Redesigning the desktop or changing existing defaults for aesthetic reasons
- Removing upstream dwm functionality to make a smaller port

## Session lifecycle

The installer must add a dedicated X session entry under
`/usr/share/xsessions/`. It must not change LightDM's configured greeter or
default session automatically. The user can choose XFCE4 or dwm-titus from the
LightDM session selector.

The dwm-titus session must start only its own session services. It must not
start `xfce4-panel`, `xfdesktop`, or `xfwm4` in the dwm-titus session.
Switching back to XFCE4 must continue to work normally.

## Native bar migration

The native dwm bar is the Debian replacement for the Quickshell panel. First
inventory the existing panel widgets, status sources, menus, tray behavior,
keyboard layout indicator, and popup interactions. Then map each capability
to the existing dwm bar or a small X11-compatible helper.

Prefer existing upstream status/helper implementations where possible. Do not
introduce a second panel or a permanently running duplicate status provider.
Document any behavior that cannot be reproduced by the native bar before
changing or dropping it.

## Development sequence

1. Import the exact upstream source baseline and record its commit.
2. Establish a clean Debian build with the original dwm implementation.
3. Add Debian dependency detection and package installation without altering
   dwm configuration.
4. Add a LightDM-compatible Xorg session while retaining XFCE4.
5. Inventory Quickshell panel behavior and implement the native dwm bar
   equivalent.
6. Adapt only Fedora-specific helper integrations that block Debian use.
7. Validate install, upgrade/preservation, session selection, logout, and
   fallback to XFCE4 in a clean Debian 13 VM.

## Validation gates

- Confirm `/etc/os-release` identifies Debian 13 Trixie before any system
  changes.
- Confirm LightDM remains the active display manager.
- Confirm XFCE4 session files and packages are not removed or overwritten.
- Build the original patched dwm sources with Debian development packages.
- Run shell syntax checks on changed scripts.
- Verify the installed session appears in LightDM and launches Xorg/dwm.
- Verify the native bar works without Quickshell installed.
- Verify XFCE4 can still be selected and launched after installation.
- Record VM image, architecture, package versions, commands and results.
