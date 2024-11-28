#!/usr/bin/env bash
echo "Installing pipewire-audio meta package from bookworm-backports"
sudo apt install -t bookworm-backports pipewire-audio

echo "Enable pipewire related user services"
systemctl --user --now enable pipewire.service pipewire-pulse.service wireplumber.service
