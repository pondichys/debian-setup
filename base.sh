#!/usr/bin/env bash

sudo apt install nala

# Enable debian test?
# Following packages are not present or too old
# old
# -fzf 
# -zoxide
# absent:
# - chezmoi
# - fastfetch
# - lazygit
# - starship
# - yazi
# - zellij
sudo nala install bat curl fd-find git jq micro ripgrep

sudo nala install fish

# Create some directories
if [ ! -d $HOME/.local/bin ]; then
	mkdir -p $HOME/.local/bin
fi 

if [ ! -d $HOME/.local/share/fonts ]; then
	mkdir -p $HOME/.local/share/{fonts,icons,themes}
fi

# Install chezmoi dotfiles manager
cd $HOME && sh -c "$(curl -fsLS get.chezmoi.io/lb)"

cd -
