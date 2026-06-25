#!/bin/sh
set -eu

if ! command -v tailscale >/dev/null 2>&1; then
  curl -fsSL https://tailscale.com/install.sh | sh
fi

if command -v systemctl >/dev/null 2>&1 &&
  systemctl list-unit-files tailscaled.service >/dev/null 2>&1; then
  sudo systemctl enable --now tailscaled
fi
