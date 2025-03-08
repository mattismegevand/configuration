#!/usr/bin/env bash

stow term

if [[ "$OSTYPE" == "darwin"* ]]; then
    mkdir -p ~/Library/Application\ Support/Cursor/User/
    ln -sf ~/configuration/manual/cursor/settings.json ~/Library/Application\ Support/Cursor/User/settings.json

    stow personal
    xargs brew install < ~/bin/brew/leaves
    xargs brew install < ~/bin/brew/casks

    defaults write -g ApplePressAndHoldEnabled -bool false
elif [[ "$OSTYPE" == "linux"* ]]; then
    mkdir -p ~/.config/Cursor/User
    ln -sf ~/configuration/cursor/settings.json ~/.config/Cursor/User/settings.json

    stow work
fi
