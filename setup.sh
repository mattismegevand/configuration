#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

if ! command -v stow >/dev/null 2>&1; then
    printf '%s\n' "GNU stow is required for setup." >&2
    exit 1
fi

stow misc
stow term

if [[ "$OSTYPE" == "darwin"* ]]; then
    if command -v brew >/dev/null 2>&1; then
        brew bundle --file=personal/bin/brew/Brewfile
        brew analytics off
    else
        printf '%s\n' "Homebrew not found; skipping bundle install." >&2
    fi

    defaults write -g ApplePressAndHoldEnabled -bool false
    defaults write -g KeyRepeat -int 1
elif [[ "$OSTYPE" == "linux"* ]]; then
    :
fi
