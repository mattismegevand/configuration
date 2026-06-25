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

if ! command -v tailscale >/dev/null 2>&1; then
  curl -fsSL https://tailscale.com/install.sh | sh
fi

if command -v systemctl >/dev/null 2>&1 &&
  systemctl list-unit-files tailscaled.service >/dev/null 2>&1; then
  sudo systemctl enable --now tailscaled
fi
