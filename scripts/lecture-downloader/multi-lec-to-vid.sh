#!/usr/bin/env bash

working_dir=$(pwd)
filename="$working_dir/lectures.txt"

function lec-to-vid() {
	ffmpeg -protocol_whitelist \
	file,http,https,tcp,tls,crypto \
	-i $1 -c copy -bsf:a aac_adtstoasc output/$2.mp4
}

n=1
while read line; do
	lec-to-vid $line $n &
	n=$((n+1))
done < $filename
