#!/usr/bin/env bash

echo "Installing build dependencies for neovim ..."
sudo apt-get install ninja-build gettext cmake unzip curl build-essential

echo "Cloning neovim repository"
cd $HOME/git && git clone https://github.com/neovim/neovim

echo "Building latest stable version of neovim"
cd neovim && git checkout stable && make CMAKE_BUILD_TYPE=RelWithDebInfo

echo "Installing Neovim from local package"
cd build && cpak -G DEB && sudo dpkg -i nvim-linux64.deb
