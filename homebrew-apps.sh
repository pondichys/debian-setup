#!/usr/bin/env bash

brew_apps=(
  "chezmoi"
  "eza"
  "fastfetch"
  "fzf"
  "git-delta"
  "lazygit"
  "neovim"
  "starship"
  "yazi"
)

echo "Installing applications with HomeBrew"
for app in "${brew_apps[@]}"; do
    echo "Installing ${app} ..."
    brew install "${app}"
done

