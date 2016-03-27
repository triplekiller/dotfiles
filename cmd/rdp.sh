#!/bin/bash

# Remote access to Windows from Linux

nohup rdesktop -z -x 0x80 -a 16 -g 1680*1050 -u "MARVELL\xiasb" -f \
-r clipboard:CLIPBOARD -r disk:MRVL=/home/san/share MSH-LT1946 \
> /dev/null 2>&1 &
