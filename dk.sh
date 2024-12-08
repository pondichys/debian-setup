#!/usr/bin/env bash
echo "Installing dependencies ..."
sudo apt install libxcb-randr0-dev libxcb-util-dev libxcb-icccm4-dev libxcb-cursor-dev libxcb-keysyms1-dev libxcb-res0-dev -y

if [ -d $HOME/git ]
then
    echo "Cloning repository"
    cd $HOME/git && git clone https://bitbucket.org/natemaia/dk.git
    echo "Compiling and installing DK window manager"
    cd dk && make && sudo make install
else
    echo "No directory ${HOME}/git found. Nothing done."
fi

echo "Installing usefull tools"
sudo apt install dunst picom rofi dmenu sxhkd polybar -y
