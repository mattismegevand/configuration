#!/bin/sh
set -eu

run_as_root() {
  if [ "$(id -u)" -eq 0 ]; then
    "$@"
  else
    sudo "$@"
  fi
}

if ! command -v tailscale >/dev/null 2>&1; then
  curl -fsSL https://tailscale.com/install.sh | sh
fi

if command -v systemctl >/dev/null 2>&1 &&
  systemctl list-unit-files tailscaled.service >/dev/null 2>&1; then
  run_as_root systemctl enable --now tailscaled
fi
