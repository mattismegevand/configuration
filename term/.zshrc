export PS1=$'%n@%m:%F{cyan}%~%f$ '

export EDITOR='nvim'
export VISUAL='nvim'
export PAGER='less'

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY
setopt EXTENDED_HISTORY

unsetopt BEEP

autoload -Uz compinit
compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

bindkey -e

[[ -f ~/.aliases ]] && source ~/.aliases
[[ -f ~/.aliases_work ]] && source ~/.aliases_work

if command -v fzf &> /dev/null; then
  source <(fzf --zsh)
fi

[[ -d $HOME/bin ]] && PATH="$HOME/bin:$PATH"
[[ -d /opt/homebrew/bin ]] && PATH="/opt/homebrew/bin:$PATH"
export PATH

[ -s "/Users/mattis/.bun/_bun" ] && source "/Users/mattis/.bun/_bun"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
