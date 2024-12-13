#!/usr/bin/env bash

# Add or remove applications as needed
flatpak_apps=(
  "app.devsuite.Ptyxis"
  "com.bitwarden.desktop"
  "com.discordapp.Discord"
  "com.spotify.Client"
  "com.heroicgameslauncher.hgl"
  "com.valvesoftware.Steam"
  "fr.handbrake.ghb"
  "io.github.flattool.Warehouse"
  "io.github.giantpinkrobots.flatsweep"
  "io.github.zen_browser.zen"
  "md.obsidian.Obsidian"
  "org.gnome.Papers"
)

function flatpak_install() {
    local app_list=("$@")
    
    for app in "${app_list[@]}"; do
        echo "Installing: $app"
        if flatpak install -y "$app"; then
            echo "Successfully installed: $app"
        else
            echo "Failed to install: $app"
            echo "Please check for any error above and make sure the application name is correct."
        fi
        echo "--------------------"
    done

    echo "Flatpak applications installation process complete."
}

echo "Installing flatpak applications"
flatpak_install "${flatpak_apps[@]}"

exit 0


