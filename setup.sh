#!/usr/bin/env bash

stow git
stow term
stow tmux
stow vim

if [[ "$OSTYPE" == "darwin"* ]]; then
    stow brew
    stow zsh
    defaults write -g ApplePressAndHoldEnabled -bool false
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    stow work
    stow bash
fi
