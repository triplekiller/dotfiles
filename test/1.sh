#!/bin/sh

A=B
echo "PID for 1.sh before exec/source/fork: $$"

export A

echo "1.sh: \$A is $A"

case $1 in
	exec)
		echo "exec 2.sh..."
		exec ./2.sh
		;;
	source)
		echo "source 2.sh..."
		. ./2.sh
		;;
	*)
		echo "fork 2.sh..."
		./2.sh
		;;
esac

echo "PID for 1.sh after exec/source/fork: $$"
echo "1.sh: \$A is $A"
