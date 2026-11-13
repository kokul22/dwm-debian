#!/bin/sh
# Read-only check of upstream dwm-titus compile dependencies.
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
"$SCRIPT_DIR/check-platform.sh"

if ! command -v pkg-config >/dev/null 2>&1; then
    echo "ERROR: pkg-config is not installed." >&2
    exit 1
fi

modules="x11 xft xinerama xrender imlib2 x11-xcb xcb xcb-res fontconfig freetype2"
failed=0
for module in $modules; do
    if pkg-config --exists "$module"; then
        printf 'OK      %s %s\n' "$module" "$(pkg-config --modversion "$module")"
    else
        printf 'MISSING %s\n' "$module"
        failed=1
    fi
done

if [ "$failed" -ne 0 ]; then
    echo "Build dependency check failed." >&2
    exit 1
fi

echo "Build dependency check passed."
