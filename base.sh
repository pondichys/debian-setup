#!/usr/bin/env bash

function handle_error() {
    echo "Error: $1"
    exit 1
}

# Enable debian test?
# Following packages are not present or too old
# old
# -fzf 
# -zoxide
# absent:
# - chezmoi
# - fastfetch
# - lazygit
# - starship
# - yazi
# - zellij
sudo apt install bat curl fd-find fzf git jq ripgrep tmux vim wget

# sudo apt install fish

echo "Creating $HOME/.local directories"
if [ ! -d $HOME/.local/bin ]; then
	mkdir -pv $HOME/.local/bin
fi 

if [ ! -d $HOME/.local/share/fonts ]; then
	mkdir -pv $HOME/.local/share/{fonts,icons,themes}
fi

if ! command -v zoxide &> /dev/null
then
    echo "Installing zoxide from github"
    curl -sSfl https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
fi

if ! command -v fastfetch &> /dev/null
then
    echo "Installing fastfetch from github"

    echo "Finding latest available release"
    latest_release=$(curl -s https://api.github.com/repos/fastfetch-cli/fastfetch/releases/latest) || handle_error "Cannot retrieve latest release info"

    echo "Extracting version tag"
    version=$(echo "$latest_release" | grep '"tag_name"' | cut -d '"' -f 4) || handle_error "Cannot extract version"

    echo "Finding download URL of the AMD64 .deb package"
    deb_url=$(echo "$latest_release" | grep -E "fastfetch.*amd64\.deb" | cut -d '"' -f 4) || handle_error "Cannot find amd64 .deb package"

    echo "Downloading fastfetch version $version..."
    wget "$deb_url" -O "$HOME/fastfetch_${version}_amd64.deb" || handle_error "Failed to download"

fi

if ! command -v chezmoi &> /dev/null
then
    echo "Installing chezmoi dotfiles manager"
    cd $HOME && sh -c "$(curl -fsLS get.chezmoi.io/lb)"
fi

# Install distrobox
# curl -s https://raw.githubusercontent.com/89luca89/distrobox/main/install | sh -s -- --prefix ~/.local

echo "All base utilities are installed"
