# Use Colima only when its Docker socket is available.
set -l colima_home $HOME/.colima
if set -q COLIMA_HOME; and test -n "$COLIMA_HOME"
    set colima_home "$COLIMA_HOME"
end
if test -S "$colima_home/default/docker.sock"
    set -gx DOCKER_HOST "unix://$colima_home/default/docker.sock"
end
