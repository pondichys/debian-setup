#!/usr/bin/env bash

echo "Installing pipx"
sudo apt-get install -y pipx

echo "Installing latest ansible and ansible-dev-tools packages via pipx in the same venv"
pipx install --include-deps ansible
pipx inject --include-deps ansible ansible-dev-tools

echo "ansible and ansible-dev-tools are now available on your system"
echo "To upgrade, run pipx upgrade ansible "
