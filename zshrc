# Exit early for non-interactive shells
[[ $- != *i* ]] && return

export PS1=$'%n@%m:%F{cyan}%~%f$ '

export EDITOR='vim'
export VISUAL='vim'
export PAGER='less'
export HOMEBREW_NO_AUTO_UPDATE=1
export LESS="-R -X -F"
export FZF_DEFAULT_COMMAND="fd --type f --hidden --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type d --hidden --exclude .git"
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border"

if [ "$TERM" = "xterm-ghostty" ]; then
  export TERM=xterm-256color
fi

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
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

if command -v fzf &> /dev/null; then
  source <(fzf --zsh)
fi

if command -v mise &> /dev/null; then
  eval "$(mise activate zsh)"
fi

# Direnv - auto-load .envrc files
if command -v direnv &> /dev/null; then
  eval "$(direnv hook zsh)"
fi

# Atuin - better shell history
if command -v atuin &> /dev/null; then
  eval "$(atuin init zsh)"
fi

# Zoxide - smarter cd
if command -v zoxide &> /dev/null; then
  eval "$(zoxide init zsh)"
fi

[[ -f ~/.aliases ]] && source ~/.aliases
[[ -f ~/.aliases_work ]] && source ~/.aliases_work

# Syntax highlighting and autosuggestions (Nix-managed paths)
for p in /run/current-system/sw/share $HOME/.nix-profile/share /etc/profiles/per-user/$USER/share; do
  [[ -f "$p/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] && { source "$p/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"; break; }
done
for p in /run/current-system/sw/share $HOME/.nix-profile/share /etc/profiles/per-user/$USER/share; do
  [[ -f "$p/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] && { source "$p/zsh-autosuggestions/zsh-autosuggestions.zsh"; break; }
done
