#!/bin/bash

# Usage:
#
# ./prereqs-ubuntu16.sh
#
# User must then logout and login
#

set -e

## check the version of ubuntu
source /etc/lsb-release || echo "Release information not found"

if [[ "$DISTRIB_RELEASE" =~ 16\.[0-9][0-9] ]]; then
  echo "Installing Fabric Composer prereqs for Ubuntu 16"
else
  echo "This script is specifically for Ubuntu 16"
  exit 1
fi

# Update package lists
sudo apt-get update

# Install Git
sudo apt-get -y install git

# Install nvm dependencies
sudo apt-get -y install build-essential libssl-dev

# Execute nvm installation script
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.32.1/install.sh | bash

# Update bash profile
cat <<EOF >> ~/.profile
export NVM_DIR=~/.nvm
[ -s "\$NVM_DIR/nvm.sh" ] && . "\$NVM_DIR/nvm.sh"
EOF

# Reload bash profile
source ~/.profile

# Install node and npm
nvm install 6.9.5

# Configure nvm to use version 6.9.5
nvm use 6.9.5
nvm alias default 6.9.5

# Install the latest version of npm
npm install npm@latest -g

# Ensure that CA certificates are installed
sudo apt-get -y install apt-transport-https ca-certificates

# Add new GPG key and add it to adv keychain
sudo apt-key adv \
               --keyserver hkp://ha.pool.sks-keyservers.net:80 \
               --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

# Update where APT will search for Docker Packages
echo "deb https://apt.dockerproject.org/repo ubuntu-xenial main" | sudo tee /etc/apt/sources.list.d/docker.list

# Update package lists
sudo apt-get update

# Verifies APT is pulling from the correct Repository
sudo apt-cache policy docker-engine

# Install docker-engine
sudo apt-get -y install docker-engine

# Modify user account
sudo usermod -aG docker $(whoami)


# Install docker compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.10.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# install python 2 required for node-gyp
test -e /usr/bin/python || sudo apt-get install -y python-minimal

echo ""
echo "Installation done, versions installed are"
echo "Node:"
node --version
echo "npm:"
npm --version
echo "docker:"
docker --version
echo "docker-compose:"
docker-compose --version


# You will need to logout in order for these changes to take effect!
echo "Please logout then login before continuing."

