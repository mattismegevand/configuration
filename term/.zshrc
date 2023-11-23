source ~/.aliases

export CLICOLOR=1
export PROMPT="%n@%m:%B%F{green}%~%f%b$ "
export LSCOLORS=cxgxfxexbxegedabagacad

export EDITOR=vim
export VISUAL="$EDITOR"

bindkey -e
bindkey "^[[Z" reverse-menu-complete

export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
