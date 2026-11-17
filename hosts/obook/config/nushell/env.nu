use std/util 'path add'

$env.EDITOR = 'nvim'
$env.XDG_CONFIG_HOME = ($nu.home-dir | path join '.config')
$env.PROGRAMMING = ($nu.home-dir | path join 'Developer')
$env.DOTFILES = ($env.PROGRAMMING | path join 'dotfiles')
$env.GOPATH = ($nu.home-dir | path join '.local/share/go')
$env.STARSHIP_SHELL = 'nu'
$env.STARSHIP_CONFIG = ($env.XDG_CONFIG_HOME | path join 'starship.toml')
$env.HOMEBREW_NO_ANALYTICS = '1'

# Prefer Colima when its Docker socket is available.
let colima_home = ($env.COLIMA_HOME? | default ($nu.home-dir | path join '.colima'))
let docker_socket = ($colima_home | path join 'default/docker.sock')
if ($docker_socket | path type) == 'socket' {
    $env.DOCKER_HOST = $'unix://($docker_socket)'
}

path add '/opt/homebrew/bin'
path add '/opt/homebrew/sbin'
path add '/usr/local/MacGPG2/bin'
path add ($nu.home-dir | path join '.atuin/bin')
path add ($nu.home-dir | path join '.cargo/bin')
path add ($nu.home-dir | path join '.local/bin')
path add ($env.GOPATH | path join 'bin')

$env.VP_HOME = ($nu.home-dir | path join '.vite-plus')
$env.PNPM_HOME = ($nu.home-dir | path join 'Library/pnpm')
$env.BUN_INSTALL = ($nu.home-dir | path join '.bun')
path add ($env.BUN_INSTALL | path join 'bin')
path add $env.PNPM_HOME ($env.PNPM_HOME | path join 'bin')
path add ($env.VP_HOME | path join 'bin')
$env.PATH = ($env.PATH | append ($env.VP_HOME | path join 'fallback-bin') | uniq)
