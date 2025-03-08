export PS1=$'%n@%m:\e[0;36m%~\e[0m$ '

export EDITOR='vim'
export VISUAL='vim'
export PAGER='less'

HISTFILE=~/.history
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
bindkey '^[[A' history-beginning-search-backward
bindkey '^[[B' history-beginning-search-forward

[[ -d $HOME/bin ]] && PATH="$HOME/bin:$PATH"
[[ -d /opt/homebrew/bin ]] && PATH="/opt/homebrew/bin:$PATH"

[[ -f ~/.aliases ]] && source ~/.aliases
[[ -f ~/.aliases_work ]] && source ~/.aliases_work
