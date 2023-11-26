# Tmux shortcuts

## General

- **Prefix Key**: `Ctrl-a` (used before most tmux commands)
- **Reload tmux Configuration**: `Ctrl-a r`

### Pane Management

- **Split Pane Vertically**: `Ctrl-a |` (creates a new pane to the right)
- **Split Pane Horizontally**: `Ctrl-a -` (creates a new pane below)
- **Resize Pane Down**: `Ctrl-a j` (hold and repeat to continue resizing)
- **Resize Pane Up**: `Ctrl-a k` (hold and repeat to continue resizing)
- **Resize Pane Left**: `Ctrl-a h` (hold and repeat to continue resizing)
- **Resize Pane Right**: `Ctrl-a l` (hold and repeat to continue resizing)

- Switch Pane Up: `Ctrl-a Ctrl-k`
- Switch Pane Down: `Ctrl-a Ctrl-j`
- Switch Pane Left: `Ctrl-a Ctrl-h`
- Switch Pane Right: `Ctrl-a Ctrl-l`

### Mouse Support

- **Mouse Mode**: Enabled (allows you to interact with tmux using the mouse)

### Other Settings

- **Suppress Bell/Activity Notifications**: All types of bell notifications are turned off.
- **Status Bar**: Custom styling and information display (e.g., time, date, load average).

### Notes

- The `unbind` commands in your configuration remove the default bindings for `%`, `"`, and `r`. Therefore, the usual `split-window` and `reload-config` shortcuts are replaced with the ones listed above.
- This cheat sheet assumes that the rest of the tmux key bindings are at their defaults since they are not explicitly modified in your configuration.


Keep this cheat sheet handy for quick reference while using tmux with your custom configuration!k
