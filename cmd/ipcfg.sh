#!/bin/bash
#!/usr/bin/expect -f

case "$1" in
static)
	sudo cp -f /etc/network/interfaces.static /etc/network/interfaces
	;;

dhcp)
	sudo cp -f /etc/network/interfaces.dhcp /etc/network/interfaces
	;;

both)
	sudo cp -f /etc/network/interfaces.both /etc/network/interfaces
	;;

*)
	echo "Usage: ipcfg.sh {static|dhcp|both}"
	exit 1
	;;
esac

sudo /etc/init.d/networking restart
exit 0
