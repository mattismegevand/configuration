#!/bin/sh
set -eu

cd "$(dirname "$0")"

config_dir="$HOME/.config/cliproxyapi"
token_file="$config_dir/api-key"
claude_dir="$HOME/.claude"
claude_settings="$claude_dir/settings.json"
brew_prefix="$(brew --prefix)"
proxy_config="$brew_prefix/etc/cliproxyapi.conf"

umask 077
mkdir -p "$config_dir" "$claude_dir"

if [ ! -s "$token_file" ]; then
  openssl rand -hex 32 >"$token_file"
fi
chmod 600 "$token_file"
proxy_key="$(cat "$token_file")"

proxy_tmp="$(mktemp)"
claude_managed_tmp="$(mktemp)"
claude_current_tmp="$(mktemp)"
claude_merged_tmp="$(mktemp)"
trap 'rm -f "$proxy_tmp" "$claude_managed_tmp" "$claude_current_tmp" "$claude_merged_tmp"' EXIT

sed "s/__CLIPROXY_API_KEY__/$proxy_key/g" \
  cliproxyapi.conf.template >"$proxy_tmp"
install -m 600 "$proxy_tmp" "$proxy_config"

sed "s/__CLIPROXY_API_KEY__/$proxy_key/g" \
  claude-settings.json.template >"$claude_managed_tmp"

if [ -s "$claude_settings" ]; then
  cp "$claude_settings" "$claude_current_tmp"
else
  printf '{}\n' >"$claude_current_tmp"
fi

jq -s '
  .[0] as $current
  | .[1] as $managed
  | $current + $managed
  | .env = (($current.env // {}) + $managed.env)
' "$claude_current_tmp" "$claude_managed_tmp" >"$claude_merged_tmp"
install -m 600 "$claude_merged_tmp" "$claude_settings"

brew services restart cliproxyapi

if ! find "$HOME/.cli-proxy-api" -maxdepth 1 -name 'codex-*.json' \
  -type f -print -quit 2>/dev/null | grep -q .; then
  printf '\nCodex OAuth is not configured. Run:\n'
  printf '  cliproxyapi --codex-login\n'
fi
