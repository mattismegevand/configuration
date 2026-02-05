# SSH key management
if command -v ssh-add &> /dev/null; then
  if [[ "$(uname)" != "Darwin" ]]; then
    # Persistent agent socket so all sessions share one agent
    export SSH_AUTH_SOCK="$HOME/.ssh/agent.sock"
    if ! ssh-add -l &> /dev/null 2>&1; then
      rm -f "$SSH_AUTH_SOCK"
      eval "$(ssh-agent -a "$SSH_AUTH_SOCK")" > /dev/null
      ssh-add ~/.ssh/id_ed25519 2>/dev/null
    fi
  fi
  # macOS: 1Password handles SSH agent via IdentityAgent in ssh config
fi
