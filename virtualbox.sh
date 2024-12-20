#!/usr/bin/env bash
echo "Enabling VirtualBox repository"
sudo extrepo enable virtualbox

echo "Installing VirtualBox"
sudo apt update
sudo apt install virtualbox-7.1
