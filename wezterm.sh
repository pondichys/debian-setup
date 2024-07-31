#!/usr/bin/env bash
echo "Configuring wezterm repository"
curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list

echo " Updating package database and installing wezterm"
sudo nala update && sudo nala install wezterm

if [ "$?" -eq 0 ]; then
	echo "Wezterm successfully installed"
else
	echo "Oops an error occured."
fi
