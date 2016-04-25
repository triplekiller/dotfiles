#!/bin/bash

MATRIX="0123456789 ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz~!@#$%^&*()_+\`[]\\;',./{}|:\"<>?"
LENGTH="32"

len=$(expr $RANDOM % 31 + 1)
echo "$len"

while [ "${n:=1}" -le "$len" ]
do
	PASS="$PASS${MATRIX:$(($RANDOM%${#MATRIX})):1}"
	let n+=1
done

echo "$PASS"
exit 0
