if command -q fnm
    fnm env --use-on-cd --shell fish | source
end

# fnm
set FNM_PATH "/home/ojohnsen/.local/share/fnm"
if [ -d "$FNM_PATH" ]
  set PATH "$FNM_PATH" $PATH
  fnm env | source
end

# fnm
set FNM_PATH "/home/ojohnsen/.local/share/fnm"
if [ -d "$FNM_PATH" ]
  set PATH "$FNM_PATH" $PATH
  fnm env | source
end
