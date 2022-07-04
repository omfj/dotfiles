stream_video=$(youtube-dl -f best --get-url https://pstreaming01.app.uib.no/vnlive/498cd9ae-d3dc-441a-9dd1-5adb55590aa1-presentation-delivery.stream/media_w237889768_576.ts)

ffmpeg -i $stream_video out.mp4
