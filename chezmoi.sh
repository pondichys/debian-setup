#!/usr/bin/env bash
echo "Install chezmoi dotfiles manager"
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b $HOME/.local/bin
