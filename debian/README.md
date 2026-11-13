# Debian build layer

These files are the first Debian-specific build layer. They intentionally do
not modify upstream C sources or user configuration.

## Build dependencies

The package list maps the upstream `config.mk` pkg-config modules to Debian
13 Trixie development packages. The package names were checked against Debian
Trixie package metadata:

- `libxft-dev` and `libxrender-dev` provide Xft/Render development support.
- `libxinerama-dev` provides Xinerama headers and libraries.
- `libimlib2-dev` provides Imlib2 development files.
- `libx11-xcb-dev`, `libxcb1-dev`, and `libxcb-res0-dev` provide the Xlib/XCB
  and XCB resource modules.
- `libfontconfig1-dev` and `libfreetype-dev` provide font configuration and
  FreeType development files.

References: Debian Trixie package pages for
[libxft-dev](https://packages.debian.org/trixie/libdevel/libxft-dev),
[libimlib2-dev](https://packages.debian.org/trixie/libdevel/libimlib2-dev),
and [libxcb-res0-dev](https://packages.debian.org/trixie/libdevel/libxcb-res0-dev).

## On the Debian 13 VM

From the repository root:

```sh
chmod +x debian/*.sh
./debian/check-platform.sh
./debian/install-build-deps.sh
./debian/check-build-deps.sh
```

The install script changes only APT package state. It does not install a
display manager, change the default display manager, remove XFCE4, or install
a new login session.

The next gate is importing the exact upstream source baseline, then running
the original project build unchanged before making any Debian-specific source
patches.
