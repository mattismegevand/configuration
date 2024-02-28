source ~/.aliases

export CLICOLOR=1
export PROMPT="%n@%m:%B%F{green}%~%f%b$ "
export LSCOLORS=cxgxfxexbxegedabagacad

export EDITOR=nvim
export VISUAL="$EDITOR"

bindkey -e
bindkey "^[[Z" reverse-menu-complete

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

[ -s "/Users/mattis/.bun/_bun" ] && source "/Users/mattis/.bun/_bun"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
