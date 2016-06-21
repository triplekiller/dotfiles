#!/bin/bash

# Prevent unset variables
set -u
# Stop on an error
set -e
# Pipe exit code should be non-zero when a command in it fails
set -o pipefail
# Stricter IFS settings
IFS=$'\t\n'
ORIGINAL_IFS=$IFS

dotfiles_dir=$(pwd)/conf
vundle_dir=$HOME/.vim/bundle/Vundle.vim

# List of space separated files/folders to symlink in $HOME
files="vimrc tmux.conf"

remove_dir_if_exists() {
	local directory="$1"

	if [ -d "$directory" ]; then
		rm -rf "$directory"
	fi
}

symlink_and_backup() {
	local src="$1"
	local dst="$2"

	if [ -L $dst ]; then
		echo "Removing $dst symlink"
		rm -f $dst
	elif [ -e $dst ]; then
		echo "Backup existing $dst"
		mv $dst ${dst}.bk
	fi

	echo "Symlinking $dst -> $src"
	ln -s "$src" "$dst"
}

IFS=$' '
for file in $files; do
	oldfile="$HOME/.$file"
	symlink_and_backup $dotfiles_dir/$file $oldfile
done
IFS=$ORIGINAL_IFS

# If Vundle is already installed, remove it and fetch the latest from github
remove_dir_if_exists $vundle_dir
echo "Installing vim plugins..."
git clone https://github.com/VundleVim/Vundle.vim.git $vundle_dir
vim +PluginInstall +qall
