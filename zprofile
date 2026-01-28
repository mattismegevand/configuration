# SSH key management (runs once per login session)
if command -v ssh-add &> /dev/null; then
  SSH_KEY="$HOME/.ssh/id_ed25519"
  SSH_KEY_FP=""
  if [[ -r "$SSH_KEY" ]] && command -v ssh-keygen &> /dev/null; then
    SSH_KEY_FP="$(ssh-keygen -lf "$SSH_KEY" 2>/dev/null | awk '{print $2}')"
  fi

  if [[ "$(uname)" == "Darwin" ]]; then
    if [[ -n "$SSH_KEY_FP" ]] && ! ssh-add -l 2>/dev/null | awk '{print $2}' | grep -qF "$SSH_KEY_FP"; then
      ssh-add --apple-use-keychain "$SSH_KEY" > /dev/null 2>&1
    fi
  else
    if [[ -z "${SSH_AUTH_SOCK:-}" ]] || ! ssh-add -l &> /dev/null; then
      eval "$(ssh-agent -s)" > /dev/null
    fi
    if [[ -n "$SSH_KEY_FP" ]] && ! ssh-add -l 2>/dev/null | awk '{print $2}' | grep -qF "$SSH_KEY_FP"; then
      ssh-add "$SSH_KEY" > /dev/null 2>&1
    fi
  fi
  unset SSH_KEY_FP
fi
