# dwm-debian

A Debian 13 compatibility port of [dwm-titus](https://github.com/ChrisTitusTech/dwm-titus).

## Project direction

This repository preserves the upstream dwm-titus desktop experience and adapts
its platform integration for Debian. It is a compatibility port, not a redesign.

- Preserve the upstream patched dwm implementation, configuration, keybindings,
  layouts, window rules, themes, helper behavior, and user workflows.
- Replace the Quickshell panel with the native dwm bar and Debian-compatible
  X11 status components.
- Keep XFCE4 installed as the existing desktop environment.
- Use LightDM as the display manager and greeter.
- Add dwm-titus as a separate selectable Xorg session; do not replace XFCE4.
- Keep the Fedora upstream project and its Fedora-specific behavior untouched.

## Target platform

- Debian GNU/Linux 13 (Trixie), amd64
- XFCE4 retained
- LightDM retained
- Xorg/X11 session
- Native dwm bar; no Quickshell runtime dependency

## Development status

The first development branch is `feature/core-dwm`. The initial work is the
upstream source baseline and Debian platform/session compatibility layer.
Runtime behavior is not considered validated until it has been built and tested
in the Debian 13 VM.

See [PORTING.md](PORTING.md) for the compatibility contract and work sequence.
