#!/bin/sh
set -eu

cd "$(dirname "$0")"

case "$(uname)" in
  Darwin)
    os=macos
    brew bundle --file="./macos/Brewfile"
    ./macos/setup.sh
    ;;
  Linux)
    os=linux
    . /etc/os-release
    if [ "${ID:-}" != "ubuntu" ]; then
      printf 'Unsupported Linux distribution: %s\n' "${ID:-unknown}" >&2
      exit 1
    fi
    sudo apt-get update
    xargs sudo apt-get install -y <"./linux/packages.txt"
    xargs sudo snap install <"./linux/snaps.txt"
    ./linux/setup.sh
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
    git homebrew ssh
elif [ "$os" = "linux" ]; then
  stow --no-folding --target="$HOME" --restow --dir="$PWD/linux/stow" \
    git ssh
fi

chmod 600 "$HOME/.ssh/config"
