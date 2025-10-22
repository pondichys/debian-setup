#!/usr/bin/env bash

echo "Enable numlock on Gnome startup"
gsettings set org.gnome.desktop.peripherals.keyboard numlock-state true
