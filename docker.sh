#!/usr/bin/bash
echo "Enabling docker-ce repository using extrepo"
sudo extrepo enable docker-ce

"Installing Docker CE"
sudo apt-get update
sudo apt-get install -y docker-ce 