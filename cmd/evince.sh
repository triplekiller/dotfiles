#!/bin/bash

# Move this script into ${HOME}/.mycmds
# Append the following line in ${HOME}/.bashrc
# export PATH="$PATH:$HOME/.mycmds"

function print_help()
{
# here-document
cat <<EOF

Usage: ${0##*/} <xxx.pdf>
-h, --help  display the help

EOF
}

if [ $# -ne 1 ]; then
	print_help
	exit 1
fi

# 2>&1 --> merge output from STDERR with STDOUT
nohup evince "$1" > /dev/null 2>&1 &
