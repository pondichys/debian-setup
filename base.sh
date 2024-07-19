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
sudo nala install bat fd-find git jq micro ripgrep

sudo nala install fish
