#!/bin/sh
set -eu

run_as_root() {
  if [ "$(id -u)" -eq 0 ]; then
    "$@"
  else
    sudo "$@"
  fi
}

install_apt_key() {
  url=$1
  destination=$2

  curl -fsSL "$url" |
    run_as_root gpg --dearmor --batch --yes --output "$destination"
}

install_1password_repository() {
  if [ "$(dpkg --print-architecture)" != amd64 ]; then
    printf '1Password automatic installation currently supports amd64 only.\n' >&2
    return
  fi

  install_apt_key \
    https://downloads.1password.com/linux/keys/1password.asc \
    /usr/share/keyrings/1password-archive-keyring.gpg
  printf '%s\n' \
    'deb [arch=amd64 signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/amd64 stable main' |
    run_as_root tee /etc/apt/sources.list.d/1password.list >/dev/null

  run_as_root mkdir -p \
    /etc/debsig/policies/AC2D62742012EA22 \
    /usr/share/debsig/keyrings/AC2D62742012EA22
  curl -fsSL \
    https://downloads.1password.com/linux/debian/debsig/1password.pol |
    run_as_root tee \
      /etc/debsig/policies/AC2D62742012EA22/1password.pol >/dev/null
  install_apt_key \
    https://downloads.1password.com/linux/keys/1password.asc \
    /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg

  install_1password_package=yes
}

install_helium_repository() {
  install_apt_key \
    https://raw.githubusercontent.com/imputnet/helium-linux/main/pubkey.asc \
    /usr/share/keyrings/helium.gpg
  printf '%s\n' \
    'deb [arch=amd64,arm64 signed-by=/usr/share/keyrings/helium.gpg] https://pkg.helium.computer/deb stable main' |
    run_as_root tee /etc/apt/sources.list.d/helium.list >/dev/null
}

install_1password_package=no
install_1password_repository
install_helium_repository
run_as_root apt-get update
run_as_root apt-get install -y helium-bin
if [ "$install_1password_package" = yes ]; then
  run_as_root apt-get install -y 1password
fi

if ! command -v ghostty >/dev/null 2>&1; then
  /bin/bash -c \
    "$(curl -fsSL https://raw.githubusercontent.com/mkasberg/ghostty-ubuntu/HEAD/install.sh)"
fi

if ! command -v tailscale >/dev/null 2>&1; then
  curl -fsSL https://tailscale.com/install.sh | sh
fi

if command -v systemctl >/dev/null 2>&1 &&
  systemctl list-unit-files tailscaled.service >/dev/null 2>&1; then
  run_as_root systemctl enable --now tailscaled
fi
