export TERM=xterm-256color
export CLICOLOR=1
export PS1='\u@\h:\[\e[33m\]\w\[\e[0m\]\$ '

case "$OSTYPE" in
  linux*)
    alias ls='ls --color=auto'
    alias grep='grep --colour=auto'
    alias egrep='egrep --colour=auto'
    alias fgrep='fgrep --colour=auto'
    ;;
esac

if [ -f ~/.aliases ]; then
    . ~/.aliases
fi

if [ -d "$HOME/bin" ] ; then
    export PATH="$HOME/bin:$PATH"
fi

if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
