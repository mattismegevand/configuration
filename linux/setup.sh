#!/bin/sh
set -eu

mkdir -p "$HOME/.local/bin"

# Ubuntu/Debian packages fd as fdfind; expose the common fd command name.
if command -v fdfind >/dev/null 2>&1 && ! command -v fd >/dev/null 2>&1; then
  ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
fi
