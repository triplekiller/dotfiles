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

function start_sshfs() {
	can_mount
	if [ $? -eq 0 ]; then
		echo "Already mounted, first umount..."
		exit 1
	fi

	sshfs -o uid=$(id -u) -o gid=$(id -u) -o sshfs_sync -o reconnect -o \
		follow_symlinks san@one77.local:/home/san/aosp /home/san/mnt/aosp/ \

	sleep 2

	sshfs -o uid=$(id -u) -o gid=$(id -u) -o sshfs_sync -o reconnect -o \
		follow_symlinks san@one77.local:/home/san/git/alp/armada/buildroot-new/out/abox_hub/images \
		/tftpboot/abox_hub
}

function stop_sshfs() {
	can_mount
	if [ $? -eq 1 ]; then
		echo "Already umounted..."
		exit 1
	fi

	fusermount -u /home/san/mnt/aosp
	fusermount -u /tftpboot/abox_hub
}

function print_usage() {
	cat << EOF

Usage: ${0##*/} [option]
Mount your remote directory using sshfs.
  -h, --help    display this help and test
  -m --mount    mount the directory
  -u, --umount  umount the directory
EOF

	exit 1
}

[ $# -eq 0 ] && print_usage

GETOPT="$(which getopt)"
ARGS=$(${GETOPT} -o hmu -l "help,mount,umount" -n "${0##*/}" -- "$@")
if [ $? -ne 0 ]; then print_usage; fi;
eval set -- "$ARGS"

while true; do
	case "$1" in
		-h|--help) shift; print_usage;;
		-m|--mount) shift; start_sshfs;;
		-u|--umount) shift; stop_sshfs;;
		--) shift; break;;
		*) echo "Internal error..."; exit 1;;
	esac
done

exit 0
