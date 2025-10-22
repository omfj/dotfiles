if not set -q TMUX
    set -g TMUX tmux new-session -d -s base -c $HOME
    eval $TMUX
    tmux attach-session -d -t base
end

