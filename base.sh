#!/usr/bin/env bash

echo "Installing base utilities"
sudo apt install bat curl fd-find fzf git jq ripgrep tmux vim wget

"Install fish shell"
sudo apt install fish

echo "Installing curated list of external repositories"
sudo apt install extrepo
echo "You can use extrepo enable ... to enable external repositories like Librewolf, Brave, VS Code, etc ..."

echo "Creating $HOME/.local directories"
if [ ! -d $HOME/.local/bin ]; then
	mkdir -pv $HOME/.local/bin
fi 

if [ ! -d $HOME/.local/share/fonts ]; then
	mkdir -pv $HOME/.local/share/{fonts,icons,themes}
fi

echo "All base utilities are installed"
