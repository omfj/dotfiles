if command -q xcrun
    set -gx SDKROOT (xcrun --show-sdk-path)
end

