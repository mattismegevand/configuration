#!/usr/bin/env bash

stow git
stow term
stow tmux
stow vim

if [[ "$OSTYPE" == "darwin"* ]]; then
    stow mac
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    stow linux 
fi
