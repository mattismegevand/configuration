# Exit early for non-interactive shells
[[ $- != *i* ]] && return

export PS1=$'%n@%m:%F{cyan}%~%f$ '

export EDITOR='vim'
export VISUAL='vim'
export PAGER='less'
export HOMEBREW_NO_AUTO_UPDATE=1
export LESS="-R -X -F"
export FZF_DEFAULT_COMMAND="find . -path '*/.git' -prune -o -type f -print"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="find . -path '*/.git' -prune -o -type d -print"
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border"

# Some remote hosts lack Ghostty terminfo; keep local capabilities intact and
# downgrade TERM only for SSH sessions.
ssh() {
  if [[ "$TERM" == "xterm-ghostty" ]]; then
    TERM=xterm-256color command ssh "$@"
  else
    command ssh "$@"
  fi
}

# Note: secrets here are exported to all child processes
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
HISTSIZE=50000
SAVEHIST=50000
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY
setopt EXTENDED_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_FIND_NO_DUPS

unsetopt BEEP

bindkey -e

setopt EXTENDED_GLOB
autoload -Uz compinit
ZCOMPDUMP="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/.zcompdump"
mkdir -p "${ZCOMPDUMP:h}"
# Only regenerate once per day
if [[ -n ${ZCOMPDUMP}(#qN.mh+24) ]]; then
  compinit -d "$ZCOMPDUMP"
else
  compinit -C -d "$ZCOMPDUMP"
fi
[[ "$ZCOMPDUMP" -nt "$ZCOMPDUMP.zwc" ]] && zcompile "$ZCOMPDUMP"
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# fzf's shell integration installs ZLE widgets; skip it for `zsh -ic ...`
# shells where the line editor is not active.
if [[ -t 0 && -t 1 ]] && command -v fzf &> /dev/null; then
  source <(fzf --zsh)
fi

if command -v mise &> /dev/null; then
  eval "$(mise activate zsh)"
fi

# Direnv - auto-load .envrc files
if command -v direnv &> /dev/null; then
  eval "$(direnv hook zsh)"
fi

[[ -f ~/.aliases ]] && source ~/.aliases
[[ -f ~/.aliases_work ]] && source ~/.aliases_work

