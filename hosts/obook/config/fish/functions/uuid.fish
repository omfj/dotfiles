function uuid
    set -l id (uuidgen | string lower)
    if command -q pbcopy
        printf %s "$id" | pbcopy
    else if command -q wl-copy
        printf %s "$id" | wl-copy
    else if command -q xclip
        printf %s "$id" | xclip -selection clipboard
    end
    echo "$id"
end
