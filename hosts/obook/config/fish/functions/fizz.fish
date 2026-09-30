function fizz
    fzf --preview "bat -n -f {}" --preview-window=right:50%:wrap --ansi --height 40% --border --prompt "Search: "
end
