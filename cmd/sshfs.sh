#!/bin/bash

function can_mount() {
	local mount_cnt
	mount_cnt=$(mount | grep sshfs | wc -l)
	if [ $mount_cnt -eq 0 ]; then
		return 1
	else
		return 0
	fi
}

function sshfs_mount() {
	can_mount
	if [ $? -eq 0 ]; then
		echo "Already mounted, first umount..."
		exit 1
	fi

	local mount_dev
	local mount_dir

	mount_dev="$1"
	mount_dir="$HOME/mnt/"`basename "$mount_dev"`
	mkdir -p "$mount_dir"

#	sshfs -o uid=$(id -u) -o gid=$(id -u) -o sshfs_sync -o reconnect -o \
#		follow_symlinks san@one77.local:/home/san/aosp /home/san/mnt/aosp/ \

	sshfs -o uid=$(id -u) -o gid=$(id -u) -o sshfs_sync -o reconnect -o \
		follow_symlinks "$mount_dev" "$mount_dir"
}

function sshfs_umount() {
	can_mount
	if [ $? -eq 1 ]; then
		echo "Already umounted..."
		exit 1
	fi

	local mount_dir
	mount_dir="$1"

	fusermount -u "$mount_dir"
}

function print_usage() {
	cat << EOF

Usage: ${0##*/} [option]
 ${0##*/} -h
 ${0##*/} <source> <directory>
 ${0##*/} -u <directory>

Mount your remote directory using sshfs.

Options:
 -h, --help                display this help and exit
 -m, --mount  <src> <dir>  mount the directory
 -u, --umount <dir>        umount the directory
EOF

	exit 1
}

[ $# -lt 2 ] && print_usage

GETOPT="$(which getopt)"
ARGS=$(${GETOPT} -o "hm:u:" -l "help,mount,umount" -n "${0##*/}" -- "$@")
if [ $? -ne 0 ]; then print_usage; fi;
eval set -- "$ARGS"

while true; do
	case "$1" in
		-h|--help) shift; print_usage;;
		-m|--mount) shift; sshfs_mount "$1";;
		-u|--umount) shift; sshfs_umount "$1";;
		--) shift; break;;
		*) echo "Internal error..."; exit 1;;
	esac
done

exit 0
