#!/bin/bash -

############################################################################### 
# Set flags so script is executed in "strict mode"
############################################################################### 

set -u # Prevent unset variables
set -e # Stop on an error
set -o pipefail # Pipe exit code should be non-zero when a command in it fails
IFS=$'\t\n' # Stricter IFS settings
ORIGINAL_IFS=$IFS

sudo apt-get -y install git
sudo apt-get -y install vim
sudo apt-get -y install tmux
sudo apt-get -y install curl

sudo apt-get -y install python3
# Install pip to install Python package easily
sudo apt-get -y install python3-pip
# Install the Python autocompletion library Jedi
sudo pip3 install -U jedi
