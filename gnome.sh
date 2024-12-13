#!/usr/bin/env bash
echo "Installing gnome core package and required dependencies ..."
sudo apt install -y gnome-core gnome-tweaks

echo "Installing gnome extension manager"
sudo apt install -y \
#	gnome-shell-extension-appindicator \
#	gnome-shell-extension-caffeine \
#	gnome-shell-extension-dashtodock \
	gnome-shell-extension-manager

echo "Its now time to reboot to activate the changes!"
echo "Run systemctl reboot to restart your system."

