#!/usr/bin/env bash

echo "Enable numlock on Gnome startup"
gsettings set org.gnome.desktop.peripherals.keyboard numlock-state true

echo "Enable minimize and maximize buttons"
gsettings set org.gnome.desktop.wm.preferences button-layout ":minimize,maximize,close"

