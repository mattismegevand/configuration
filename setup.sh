#!/usr/bin/env bash

stow git
stow term
stow tmux
stow vim

if [[ "$OSTYPE" == "darwin"* ]]; then
    stow aerospace
    stow brew
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    stow sway 
fi
