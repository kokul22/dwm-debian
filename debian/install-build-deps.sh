#!/bin/sh
# Install only the compile-time packages needed by upstream dwm-titus.
# This does not change the display manager, desktop environment, or session.
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
REPO_ROOT=$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd)

"$SCRIPT_DIR/check-platform.sh"

if ! command -v apt-get >/dev/null 2>&1; then
    echo "ERROR: apt-get is required." >&2
    exit 1
fi

if [ "$(id -u)" -eq 0 ]; then
    SUDO=""
elif command -v sudo >/dev/null 2>&1; then
    SUDO="sudo"
else
    echo "ERROR: Run as root or install sudo." >&2
    exit 1
fi

# shellcheck disable=SC2046
set -- $(grep -Ev '^[[:space:]]*(#|$)' "$SCRIPT_DIR/build-deps.txt")
if [ "$#" -eq 0 ]; then
    echo "ERROR: No build packages found." >&2
    exit 1
fi

printf 'Installing upstream dwm-titus build dependencies: %s\n' "$*"
$SUDO apt-get update
$SUDO apt-get install --no-install-recommends -y "$@"

echo
echo "Checking upstream pkg-config modules..."
modules="x11 xft xinerama xrender imlib2 x11-xcb xcb xcb-res fontconfig freetype2"
missing=""
for module in $modules; do
    if ! pkg-config --exists "$module"; then
        missing="$missing $module"
    fi
done

if [ -n "$missing" ]; then
    echo "ERROR: Missing pkg-config modules:$missing" >&2
    echo "Check Debian package availability and the upstream config.mk module list." >&2
    exit 1
fi

echo "All required pkg-config modules are available."
echo "No display-manager or XFCE4 configuration was changed."
