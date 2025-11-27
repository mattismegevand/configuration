export PS1=$'%n@%m:%F{cyan}%~%f$ '

export EDITOR='vim'
export VISUAL='vim'
export PAGER='less'

if [ "$TERM" = "xterm-ghostty" ]; then
  export TERM=xterm-256color
fi

if [ -f "$HOME/.env" ]; then
  set -a
  source "$HOME/.env"
  set +a
fi

typeset -U path PATH
[[ -d /opt/homebrew/bin ]] && path=(/opt/homebrew/bin $path)
[[ -d $HOME/bin ]] && path=("$HOME/bin" $path)
[[ -d $HOME/.local/bin ]] && path=("$HOME/.local/bin" $path)
[[ -d $HOME/.bun/bin ]] && path=("$HOME/.bun/bin" $path)

[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY
setopt EXTENDED_HISTORY

unsetopt BEEP

bindkey -e

autoload -Uz compinit
ZCOMPDUMP="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/.zcompdump"
mkdir -p "${ZCOMPDUMP:h}"
compinit -d "$ZCOMPDUMP"
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

if command -v fzf &> /dev/null; then
  fzf_base="${HOMEBREW_PREFIX:-}"
  if [[ -z "$fzf_base" ]] && command -v brew &> /dev/null; then
    fzf_base="$(brew --prefix 2>/dev/null)"
  fi

  if [[ -n "$fzf_base" && -r "$fzf_base/opt/fzf/shell/completion.zsh" ]]; then
    source "$fzf_base/opt/fzf/shell/completion.zsh"
    source "$fzf_base/opt/fzf/shell/key-bindings.zsh"
  elif [[ -r /usr/share/doc/fzf/examples/key-bindings.zsh ]]; then
    source /usr/share/doc/fzf/examples/key-bindings.zsh
    [[ -r /usr/share/doc/fzf/examples/completion.zsh ]] && source /usr/share/doc/fzf/examples/completion.zsh
  else
    source <(fzf --zsh)
  fi

  unset fzf_base
fi

if command -v mise &> /dev/null; then
  eval "$(mise activate zsh)"
fi

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

[[ -f ~/.aliases ]] && source ~/.aliases
[[ -f ~/.aliases_work ]] && source ~/.aliases_work
