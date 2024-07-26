#!/usr/bin/env bash
sudo nala install flatpak

# Configure flathub
flatpak remote-add --if-not-exists flathub \
https://dl.flathub.org/repo/flathub.flatpakrepo
