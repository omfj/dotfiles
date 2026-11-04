# cd into a git worktree picked with fzf (see `git wpick`)
function wcd
    set -l dir (git wpick)
    and test -n "$dir"
    and cd $dir
end
