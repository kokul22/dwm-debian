#!/bin/sh
# Read-only platform guard for the Debian 13 port.
set -eu

OS_RELEASE=/etc/os-release
if [ ! -r "$OS_RELEASE" ]; then
    echo "ERROR: Cannot read $OS_RELEASE; refusing platform detection." >&2
    exit 1
fi

# shellcheck disable=SC1091
. "$OS_RELEASE"

if [ "${ID:-}" != debian ]; then
    echo "ERROR: This port targets Debian 13 only (detected ID=${ID:-unknown})." >&2
    exit 1
fi

if [ "${VERSION_ID:-}" != 13 ] || [ "${VERSION_CODENAME:-}" != trixie ]; then
    echo "ERROR: Debian 13 Trixie is required (detected version=${VERSION_ID:-unknown}, codename=${VERSION_CODENAME:-unknown})." >&2
    exit 1
fi

ARCH=$(dpkg --print-architecture 2>/dev/null || true)
if [ "$ARCH" != amd64 ]; then
    echo "ERROR: Debian amd64 is required (detected architecture=${ARCH:-unknown})." >&2
    exit 1
fi

printf 'Platform check passed: Debian %s (%s), architecture %s.\n' \
    "$VERSION_ID" "$VERSION_CODENAME" "$ARCH"

if command -v lightdm >/dev/null 2>&1; then
    echo "LightDM: installed"
else
    echo "LightDM: not detected (the installer must not silently replace the current display manager)"
fi

if dpkg-query -W -f='${Status}' xfce4 2>/dev/null | grep -q 'install ok installed'; then
    echo "XFCE4: installed"
else
    echo "XFCE4: not detected (preserve existing desktop; do not remove or replace it)"
fi
