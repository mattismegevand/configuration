#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

if ! command -v brew >/dev/null 2>&1; then
    printf '%s\n' "Homebrew not found; cannot update Brewfile." >&2
    exit 1
fi

brew bundle dump --file=Brewfile --force --no-vscode
