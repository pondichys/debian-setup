#!/usr/bin/env bash
echo "Enabling brave repository"
sudo extrepo enable brave_release
sudo apt update

echo "Installing Brave browser"
sudo apt install brave-browser
