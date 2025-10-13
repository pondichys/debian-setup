#!/usr/bin/env bash
echo "Installing gnome core package and required dependencies ..."
sudo apt-get install -y gnome-core gnome-tweaks ptyxis network-manager-applet

#echo "Installing gnome extension manager"
#sudo apt install -y \
#	gnome-shell-extension-appindicator \
#	gnome-shell-extension-caffeine \
#	gnome-shell-extension-dashtodock \
#	gnome-shell-extension-manager
echo "Removing zutty terminal"
sudo apt-get remove zutty

echo "Removing /etc/network/interfaces so that Gnome can manage network."
sudo mv -i /etc/network/interfaces /etc/network/interfaces.bak
sudo touch /etc/network/interfaces

echo "Its now time to reboot to activate the changes!"
echo "Run systemctl reboot to restart your system."

