#!/bin/bash -

################################################################################
# Set flags so script is executed in "strict mode"
################################################################################

set -u # Prevent unset variables
set -e # Stop on an error
set -o pipefail # Pipe exit code should be non-zero when a command in it fails
IFS=$'\t\n' # Stricter IFS settings
ORIGINAL_IFS=$IFS

################################################################################
# Install prerequisite packages
################################################################################

sudo apt-get -y install git
sudo apt-get -y install vim
sudo apt-get -y install tmux
sudo apt-get -y install curl

sudo apt-get -y install python3
sudo apt-get -y install python3-pip
# Install the Python autocompletion library Jedi
# sudo path: /usr/local/lib/python3.5/dist-packages/jedi
# user path: pip3 install --user jedi
sudo -H pip3 install -U jedi

################################################################################
# Setup vim
################################################################################

# Clone vimrc
mkdir -p $HOME/git
cd $HOME/git
if [ ! -d dotfiles ]; then
	git clone https://github.com/triplekiller/dotfiles.git
fi
cp dotfiles/conf/vimrc $HOME/.vimrc
cd $HOME

# Clone Vundle
if [ ! -d $HOME/.vim/bundle/Vundle.vim ]; then
	git clone https://github.com/VundleVim/Vundle.vim.git $HOME/.vim/bundle/Vundle.vim
fi

# Install vim-instant-markdown plugin
sudo apt-get -y install xdg-utils curl nodejs-legacy
sudo apt-get -y install npm
# /usr/local/lib/node_modules/instant-markdown-d
sudo npm -g install instant-markdown-d

# Install Vundle plugins
vim +PluginInstall +qall

# Install clang and clang-format
sudo apt-get -y install clang clang-format
