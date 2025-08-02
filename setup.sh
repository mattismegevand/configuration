#!/usr/bin/env bash

stow misc
stow term

if [[ "$OSTYPE" == "darwin"* ]]; then
    brew bundle install --file=personal/Brewfile

    defaults write -g ApplePressAndHoldEnabled -bool false
elif [[ "$OSTYPE" == "linux"* ]]; then
    :
fi
