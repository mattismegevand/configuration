# Interactive shell configuration.
[[ -o interactive ]] || return

export EDITOR=vim
export VISUAL=vim
export PAGER=less
export LESS='-FRX'

HISTFILE="${ZDOTDIR:-$HOME}/.zsh_history"
HISTSIZE=50000
SAVEHIST=10000

setopt extended_history
setopt hist_expire_dups_first
setopt hist_find_no_dups
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt inc_append_history
setopt interactive_comments
setopt share_history

ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
mkdir -p "$ZSH_CACHE_DIR" 2>/dev/null

autoload -Uz compinit
if [[ -s "$ZSH_CACHE_DIR/zcompdump" ]]; then
  compinit -C -d "$ZSH_CACHE_DIR/zcompdump"
else
  compinit -d "$ZSH_CACHE_DIR/zcompdump"
fi
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

bindkey -e
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line

if (( $+commands[fzf] )); then
  source <(fzf --zsh)
fi

if (( $+commands[mise] )); then
  eval "$(mise activate zsh)"
fi

PROMPT='%F{cyan}%n%f@%F{blue}%m%f:%F{magenta}%~%f %(?.%F{green}.%F{red})$%f '

alias ll='ls -lah'

if [[ -r "$HOME/.zshrc.local" ]]; then
  source "$HOME/.zshrc.local"
fi
