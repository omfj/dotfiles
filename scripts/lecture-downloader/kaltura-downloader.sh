#!/usr/bin/env bash

filename="$(pwd)/lectures.txt"

function kaltura_to_mp4() {
	ffmpeg -protocol_whitelist \
	file,http,https,tcp,tls,crypto \
	-i $1 -c copy -bsf:a aac_adtstoasc output/$2.mp4
}

n=1
while read line; do
	kaltura_to_mp4 $line $n &
	n=$((n+1))
done < $filename
