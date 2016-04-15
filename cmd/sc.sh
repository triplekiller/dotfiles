#!/bin/bash

# Use avconv for screencast

# avconv -codecs | less (list codecs avconv support)

function print_usage() {
	cat << EOF

Usage: ${0##*/} [-s|-c] <xxx.mp4>
Screen cast and webcam cast using avconv.
EOF

	exit 1
}

if [ $# -ne 2 ]; then
	print_usage
fi

Xaxis=$(xrandr -q | grep '*' | uniq | awk '{print $1}' |  cut -d 'x' -f1)
Yaxis=$(xrandr -q | grep '*' | uniq | awk '{print $1}' |  cut -d 'x' -f2)

fullscreen=$(xwininfo -root | grep 'geometry' | awk '{print $2;}')

if [ "$1" = "-s" ]; then
	avconv -f alsa -i pulse -f x11grab -r 30 -s ${fullscreen} -i :0.0 -vcodec \
		libx264	-acodec libmp3lame -preset ultrafast -threads auto -y "$2"
elif [ "$1" = "-c" ]; then
	avconv -f alsa -i pulse -f video4linux2 -r 30 -i /dev/video0 -vcodec \
		libx264	-acodec libmp3lame -preset ultrafast -threads auto -y "$2"
else
	print_usage
fi

exit 0
