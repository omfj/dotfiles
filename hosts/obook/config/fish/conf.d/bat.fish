if command -q batcat
    alias bat batcat
    abbr -a cat bat
else if command -q bat
    abbr -a cat bat
end
