#!/usr/bin/env bash
echo "Checking latest LazyGit version ..."
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
echo "Found version ${LAZYGIT_VERSION}. Downloading from Github ..."
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
echo "Extracting archive"
tar xf lazygit.tar.gz lazygit
echo "Installing Lazygit binary ..."
sudo install lazygit -D -t /usr/local/bin/
echo "Cleaning up temp files"
rm lazygit.tar.gz lazygit
