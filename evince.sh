#!/bin/bash

function print_help()
{
	cat << EOF

Usage: ${0##*/} <xxx.pdf>
-h, --help  display the help text
EOF

	exit 1
}

if [ $# -ne 1 ]; then
	print_help
fi

nohup evince "$1" > /dev/null 2>&1 &
