#!/bin/bash

# include this boilerplate
function jumpto
{
	echo "0: $0"
	echo "1: $1"
	label=$1
	cmd=$(sed -n "/$label:/{:a;n;p;ba};" $0 | grep -v ':$')
	echo "cmd: $cmd"
	eval "$cmd"
	exit
}

start=${1:-"start"}

jumpto $start

start:
# your script goes here...
x=100
jumpto foo

mid:
x=101
echo "This is not printed!"

foo:
x=${x:-10}
echo x is $x
