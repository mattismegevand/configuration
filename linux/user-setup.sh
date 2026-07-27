#!/bin/sh
set -eu

mkdir -p "$HOME/.local/bin"

# Ubuntu/Debian packages fd as fdfind; expose the common fd command name.
if command -v fdfind >/dev/null 2>&1 && ! command -v fd >/dev/null 2>&1; then
  ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
fi

if ! command -v mise >/dev/null 2>&1; then
  curl -fsSL https://mise.run | sh
fi

# Match the macOS keyboard settings: 225 ms before repeating, then every 30 ms.
if command -v gsettings >/dev/null 2>&1; then
  gsettings set org.gnome.desktop.peripherals.keyboard delay 225
  gsettings set org.gnome.desktop.peripherals.keyboard repeat-interval 30
fi
