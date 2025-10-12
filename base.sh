#!/usr/bin/env bash

echo "Installing base utilities"
# wl-clipboard and xsel are needed for tmux clipboard integration under wayland / x11
sudo apt-get install bat curl fd-find git jq ripgrep vim wget wl-clipboard xsel

echo "Install fish shell"
sudo apt-get install fish

echo "Install zram-tools"
sudo apt-get install zram-tools

#echo "Installing curated list of external repositories"
#sudo apt-get install extrepo
#echo "You can use extrepo enable ... to enable external repositories like Librewolf, Brave, VS Code, etc ..."

echo "Creating $HOME/.local directories"
if [ ! -d $HOME/.local/bin ]; then
	mkdir -pv $HOME/.local/bin
fi 

if [ ! -d $HOME/.local/share/fonts ]; then
	mkdir -pv $HOME/.local/share/{fonts,icons,themes}
fi

echo "All base utilities are installed"
