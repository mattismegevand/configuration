#!/bin/sh
set -eu

cd "$(dirname "$0")"

profile="${1:-}"

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
      printf 'Usage: %s personal|server\n' "$0" >&2
      exit 1
    fi
    case "$profile" in
      personal|server) ;;
      *)
        printf 'Unsupported Linux profile: %s\n' "$profile" >&2
        exit 1
        ;;
    esac
    printf 'Installing %s profile on Linux\n' "$profile"
    . /etc/os-release
    if [ "${ID:-}" != "ubuntu" ]; then
      printf 'Unsupported Linux distribution: %s\n' "${ID:-unknown}" >&2
      exit 1
    fi
    sudo apt-get update
    xargs sudo apt-get install -y <"./linux/packages.txt"
    if [ "$profile" = "personal" ]; then
      xargs sudo snap install <"./linux/snaps.txt"
    elif [ "$profile" = "server" ]; then
      xargs sudo apt-get install -y <"./linux/server-packages.txt"
    fi
    ./linux/setup.sh
    if [ "$profile" = "server" ]; then
      ./linux/server/setup.sh
    fi
    ;;
  *)
    printf 'Unsupported OS: %s\n' "$(uname)" >&2
    exit 1
    ;;
esac

install -d -m 700 "$HOME/.ssh"

stow --no-folding --target="$HOME" --restow --dir="$PWD/common/stow" \
  ghostty git mise pi shell tmux uv vim

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
