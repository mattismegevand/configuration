#!/usr/bin/env bash

stow git
stow term
stow tmux
stow vim

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    stow aerospace
    stow brew
elif [[ "$OSTYPE" == "darwin"* ]]; then
    stow i3
fi
