set -x SDKROOT (xcrun --sdk macosx --show-sdk-path)
set -x CC /Library/Developer/CommandLineTools/usr/bin/cc
set -x CGO_CFLAGS "-O2 -g -isysroot $SDKROOT"

