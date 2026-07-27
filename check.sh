#!/bin/sh
set -eu

cd "$(dirname "$0")"

shell_scripts="
check.sh
install.sh
linux/system-setup.sh
linux/user-setup.sh
"

for script in $shell_scripts; do
  sh -n "$script"
done

zsh -n macos/setup.sh common/stow/shell/.zshrc

if command -v shellcheck >/dev/null 2>&1; then
  # macos/setup.sh targets zsh, which ShellCheck does not support.
  for script in $shell_scripts; do
    shellcheck "$script"
  done
else
  printf 'warning: shellcheck is not installed; skipping it\n' >&2
fi

toml_python=python3
if ! "$toml_python" -c 'import tomllib' >/dev/null 2>&1; then
  if command -v mise >/dev/null 2>&1; then
    toml_python="$(mise which python)"
  else
    printf 'Python 3.11+ or mise is required to validate TOML files.\n' >&2
    exit 1
  fi
fi

"$toml_python" -c '
import json
import pathlib
import tomllib

json.loads(pathlib.Path("common/stow/pi/.pi/agent/settings.json").read_text())
tomllib.loads(pathlib.Path("common/stow/mise/.config/mise/config.toml").read_text())
tomllib.loads(pathlib.Path("common/stow/uv/.config/uv/uv.toml").read_text())
'

git config -f common/stow/git/.gitconfig --list >/dev/null
git config -f macos/stow/git/.gitconfig.local --list >/dev/null
git config -f linux/stow/git/.gitconfig.local --list >/dev/null
git config -f linux/stow/git/.gitconfig.odoo --list >/dev/null

ssh -G -F common/stow/ssh/.ssh/config.common example.com >/dev/null 2>&1
ssh -G -F macos/stow/ssh/.ssh/config example.com >/dev/null 2>&1
ssh -G -F linux/stow/ssh/.ssh/config example.odoo.com >/dev/null 2>&1

if command -v plutil >/dev/null 2>&1; then
  plutil -lint \
    macos/stow/launchagents/Library/LaunchAgents/com.mattis.caps-lock-to-control.plist \
    >/dev/null
fi

stow --simulate --no-folding --target="$HOME" --restow \
  --dir="$PWD/common/stow" ghostty git mise nvim pi shell ssh tmux uv vim

case "$(uname)" in
  Darwin)
    stow --simulate --no-folding --target="$HOME" --restow \
      --dir="$PWD/macos/stow" git homebrew launchagents ssh
    ;;
  Linux)
    stow --simulate --no-folding --target="$HOME" --restow \
      --dir="$PWD/linux/stow" git ssh
    ;;
esac

git diff --check
printf 'Configuration checks passed.\n'
