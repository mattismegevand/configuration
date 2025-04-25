#!/usr/bin/env bash

stow term

if [[ "$OSTYPE" == "darwin"* ]]; then
    stow personal
    xargs brew install < ~/bin/brew/leaves
    xargs brew install < ~/bin/brew/casks

    defaults write -g ApplePressAndHoldEnabled -bool false
elif [[ "$OSTYPE" == "linux"* ]]; then
    stow work
fi
