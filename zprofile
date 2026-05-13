# SSH key management
# macOS: 1Password handles SSH agent via IdentityAgent in ssh config.
if command -v ssh-add &> /dev/null && [[ "$(uname)" != "Darwin" ]]; then
  # Persistent agent socket so all sessions share one agent.
  export SSH_AUTH_SOCK="$HOME/.ssh/agent.sock"

  ssh-add -l &> /dev/null
  agent_status=$?

  if (( agent_status > 1 )); then
    rm -f "$SSH_AUTH_SOCK"
    eval "$(ssh-agent -a "$SSH_AUTH_SOCK" -s)" > /dev/null
    agent_status=1
  fi

  if (( agent_status == 1 )) && [[ -r "$HOME/.ssh/id_ed25519" ]]; then
    ssh-add "$HOME/.ssh/id_ed25519" > /dev/null 2>&1
  fi

  unset agent_status
fi
