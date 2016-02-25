#!/bin/bash

# kermrc should be in ${HOME}/.kermrc

if [[ $1 = [0-9]*([0-9]) ]]; then
    sed -i "s/ttyUSB.*/ttyUSB$1/" ~/.kermrc
    sudo kermit -c
    exit 0
else
    echo "Usage: kermit.sh n (n is an integer)"
    exit 1
fi

#case "$1" in
#0)
#    sed -i 's/ttyUSB.*/ttyUSB0/' ~/.kermrc
#    sudo kermit -c
#    ;;
#
#1)
#    sed -i 's/ttyUSB.*/ttyUSB1/' ~/.kermrc
#    sudo kermit -c
#    ;;
#
#2)
#    sed -i 's/ttyUSB.*/ttyUSB2/' ~/.kermrc
#    sudo kermit -c
#    ;;
#
#3)
#    sed -i 's/ttyUSB.*/ttyUSB3/' ~/.kermrc
#    sudo kermit -c
#    ;;
#
#4)
#    sed -i 's/ttyUSB.*/ttyUSB4/' ~/.kermrc
#    sudo kermit -c
#    ;;
#
#*)
#    echo "Usage: kermit.sh {0|1|2|3}"
#    exit 1
#    ;;
#esac
