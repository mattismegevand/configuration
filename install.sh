#!/bin/sh
set -eu

cd "$(dirname "$0")"

if [ "$(uname)" = "Darwin" ]; then
  is_macos=1
else
  is_macos=0
fi

if [ "$is_macos" -eq 1 ]; then
  brew bundle --file="./macos/Brewfile"
  ./macos/setup.sh
fi

install -d -m 700 "$HOME/.ssh"

stow --no-folding --target="$HOME" --restow --dir="$PWD/common/stow" \
  ghostty git mise pi shell ssh tmux uv vim vscode

if [ "$is_macos" -eq 1 ]; then
  stow --no-folding --target="$HOME" --restow --dir="$PWD/macos/stow" \
    homebrew
fi

chmod 600 "$HOME/.ssh/config"
