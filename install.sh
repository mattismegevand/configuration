#!/bin/sh
set -eu

cd "$(dirname "$0")"

if [ "$(id -u)" -eq 0 ]; then
  printf 'Run this installer as a regular user; it will request sudo when needed.\n' >&2
  exit 1
fi

profile="${1:-}"

run_as_root() {
  if [ "$(id -u)" -eq 0 ]; then
    "$@"
  else
    sudo "$@"
  fi
}

install_apt_packages() {
  if [ "$(id -u)" -eq 0 ]; then
    xargs apt-get install -y <"$1"
  else
    xargs sudo apt-get install -y <"$1"
  fi
}

install_snaps() {
  if [ "$(id -u)" -eq 0 ]; then
    xargs snap install <"$1"
  else
    xargs sudo snap install <"$1"
  fi
}

case "$(uname)" in
  Darwin)
    os=macos
    profile="${profile:-personal}"
    if [ "$profile" != "personal" ]; then
      printf 'Unsupported macOS profile: %s\n' "$profile" >&2
      exit 1
    fi
    printf 'Installing %s profile on macOS\n' "$profile"
    brew bundle --file="./macos/Brewfile"
    ./macos/setup.sh
    ;;
  Linux)
    os=linux
    if [ -z "$profile" ]; then
      printf 'Usage: %s personal\n' "$0" >&2
      exit 1
    fi
    if [ "$profile" != "personal" ]; then
      printf 'Unsupported Linux profile: %s\n' "$profile" >&2
      exit 1
    fi
    printf 'Installing %s profile on Linux\n' "$profile"
    . /etc/os-release
    if [ "${ID:-}" != "ubuntu" ]; then
      printf 'Unsupported Linux distribution: %s\n' "${ID:-unknown}" >&2
      exit 1
    fi
    run_as_root apt-get update
    install_apt_packages "./linux/packages.txt"
    install_snaps "./linux/snaps.txt"
    ./linux/system-setup.sh
    ./linux/user-setup.sh
    ;;
  *)
    printf 'Unsupported OS: %s\n' "$(uname)" >&2
    exit 1
    ;;
esac

install -d -m 700 "$HOME/.ssh"

stow --no-folding --target="$HOME" --restow --dir="$PWD/common/stow" \
  ghostty git mise nvim pi shell tmux uv vim

if [ "$os" = "macos" ]; then
  stow --no-folding --target="$HOME" --restow --dir="$PWD/macos/stow" \
    git homebrew launchagents ssh

  launch_agent="$HOME/Library/LaunchAgents/com.mattis.caps-lock-to-control.plist"
  launchctl bootout "gui/$(id -u)" "$launch_agent" 2>/dev/null || true
  launchctl bootstrap "gui/$(id -u)" "$launch_agent" 2>/dev/null || true
  launchctl kickstart -k "gui/$(id -u)/com.mattis.caps-lock-to-control" 2>/dev/null || true
elif [ "$os" = "linux" ]; then
  stow --no-folding --target="$HOME" --restow --dir="$PWD/linux/stow" \
    git ssh
fi

chmod 600 "$HOME/.ssh/config"

if command -v mise >/dev/null 2>&1; then
  mise install
elif [ -x "$HOME/.local/bin/mise" ]; then
  "$HOME/.local/bin/mise" install
else
  printf 'mise was not found after setup.\n' >&2
  exit 1
fi
