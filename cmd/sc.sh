#!/bin/bash

# Use avconv for screencast

# avconv -codecs | less (list codecs avconv support)

AVCONV=$(which avconv || which ffmpeg)
AVPROBE=$(which avprobe || which ffprobe)
CONVERT=$(which convert)

function print_usage() {
	cat << EOF

Usage: ${0##*/} [-s|-c]
Screen cast and webcam cast using avconv.
EOF

	exit 1
}

if [ $# -ne 1 ]; then
	print_usage
fi

if [ "x$AVCONV" = "x" ]; then
	echo "Error: ffmpeg or avconv is not installed"
	exit 1
fi

if [ "x$AVPROBE" = "x" ]; then
	echo "Error: ffprobe or avprobe is not installed"
	exit 1
fi

if [ "x$CONVERT" = "x" ]; then
	echo "Error: convert is not installed"
	exit 1
fi

function video2gif() {
	local tmp_dir=$(mktemp -dt "video2gif.XXXXXX")
	local fps=$($AVPROBE "$1" 2>&1 | egrep "Stream.*:" | egrep -o \
		"[0-9]+[ ]+fps" | egrep -o "[0-9]+")

	echo -n "Get frames from video $1..."
	$AVCONV -i "$1" -an "$tmp_dir/out%05d.png" &>/dev/null && echo "OK" || \
		{ echo "FAIL"; rm -rf $tmp_dir; exit 1; }

	local raw_gif=$(mktemp --suffix=".gif")
	echo -n "Generate GIF image..."
	$CONVERT -delay 3 -loop 0 "$tmp_dir/*.png" $raw_gif && echo "OK" || { echo \
		"FAIL"; rm -rf $tmp_dir $raw_gif; exit 1; }

	echo -n "Optimize GIF size..."
	$CONVERT $raw_gif -fuzz 20% -layers optimize "$2" && echo "OK" || { echo \
		"FAIL"; rm -rf $tmp_dir $raw_gif; exit 1; }

	rm -rf $tmp_dir $raw_gif
	echo "All done..."
}

RESOLUTION=$(xrandr | sed -n 's/.*current \([0-9]\+\) x \([0-9]\+\).*/\1x\2/p')
VIDEO_DEV=/dev/video0
FILE_NAME=cast.mp4

trap : SIGHUP SIGINT SIGTERM

if [ "$1" = "-s" ]; then
	FILE_NAME=screencast-$(date +%Y-%m-%d-%H-%M-%S).mp4
	sleep 3
	$AVCONV -f alsa -i pulse -f x11grab -r 30 -s ${RESOLUTION} -i :0.0 -vcodec \
		libx264	-acodec libmp3lame -preset ultrafast -itsoffset 5 -threads \
		auto -y ${FILE_NAME}
elif [ "$1" = "-c" ]; then
	FILE_NAME=webcam-$(date +%Y-%m-%d-%H-%M-%S).mp4
	$AVCONV -f alsa -i pulse -f video4linux2 -r 30 -i ${VIDEO_DEV} -vcodec \
		libx264	-acodec libmp3lame -preset ultrafast -threads auto -y ${FILE_NAME}
else
	print_usage
fi

# Generate GIF from MP4
GIF_NAME=${FILE_NAME/%mp4/gif}
#video2gif ${FILE_NAME} ${GIF_NAME}

exit 0
