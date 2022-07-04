#!/usr/bin/env bash

working_dir=$(pwd)
filename="$working_dir/lectures.txt"

function inf101-lec-to-vid() {
	curl "$1" \
	-H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:96.0) Gecko/20100101 Firefox/96.0' \
	-H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8' \
	-H 'Accept-Language: en-US,en;q=0.5' \
	-H 'Accept-Encoding: gzip, deflate, br' \
	-H 'DNT: 1' \
	-H 'Connection: keep-alive' \
	-H 'Cookie: <COOKIE>' \
	-H 'Upgrade-Insecure-Requests: 1' \
	-H 'Sec-Fetch-Dest: document' \
	-H 'Sec-Fetch-Mode: navigate' \
	-H 'Sec-Fetch-Site: none' \
	-H 'Sec-Fetch-User: ?1' \
	--output $2.mp4
}

n=1
while read line; do
	inf101-lec-to-vid $line $n
	n=$((n+1))
done < $filename

