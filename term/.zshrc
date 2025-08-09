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

[[ -d $HOME/.local/bin ]] && PATH="$HOME/.local/bin:$PATH"
[[ -d $HOME/bin ]] && PATH="$HOME/bin:$PATH"
[[ -d /opt/homebrew/bin ]] && PATH="/opt/homebrew/bin:$PATH"

if command -v mise &> /dev/null; then
  eval "$(mise activate zsh)"
fi

eval "$(ssh-agent -s)" > /dev/null
SSH_KEY="$HOME/.ssh/id_ed25519"
if ! ssh-add -l | grep -q "$SSH_KEY"; then
  ssh-add --apple-use-keychain "$SSH_KEY" > /dev/null 2>&1
fi

if [ "$TERM" = "xterm-ghostty" ]; then
  export TERM=xterm-256color
fi
