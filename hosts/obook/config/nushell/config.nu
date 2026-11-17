$env.config.show_banner = false
$env.config.edit_mode = 'vi'

# Jellybeans theme for nushell
$env.config.color_config = ($env.config.color_config | merge {
    shape_internalcall: blue
    shape_external: blue
    shape_external_resolved: blue
    shape_externalarg: default
    shape_string: green
    shape_raw_string: green
    shape_string_interpolation: green
    shape_flag: purple
    shape_filepath: default_underline
    shape_directory: default_underline
    shape_globpattern: yellow
    shape_glob_interpolation: yellow
    shape_variable: purple
    shape_vardecl: purple
    shape_keyword: purple
    shape_operator: default
    shape_pipe: default
    shape_redirection: default
    shape_int: yellow
    shape_float: yellow
    shape_bool: yellow
    shape_nothing: yellow
    shape_literal: yellow
    shape_datetime: yellow
    shape_range: default
    shape_block: default
    shape_closure: default
    shape_signature: default
    shape_list: default
    shape_table: default
    shape_record: default
    shape_garbage: { fg: red, attr: u }
    hints: dark_gray
})

# Bind opt+backspace to delete the previous word in vi_insert
$env.config.keybindings ++= [{
    name: delete_previous_word
    modifier: alt
    keycode: backspace
    mode: [vi_insert]
    event: { edit: backspaceword }
}]

# Delete back to line start with cmd+backspace.
$env.config.keybindings ++= [{
    name: delete_to_line_start
    modifier: control
    keycode: char_u
    mode: [vi_insert]
    event: { edit: cutfromlinestart }
}]

$env.PROMPT_INDICATOR_VI_INSERT = ''
$env.PROMPT_INDICATOR_VI_NORMAL = ''

alias v = nvim

alias g = git
alias ga = git add
alias gc = git commit -m
alias gpf = git push --force-with-lease
alias b = brew
alias bi = brew install

def --wrapped bu [...args: string] {
    ^($env.DOTFILES | path join 'bin/update-mac') ...$args
}

alias lg = lazygit
alias dots = cd $env.DOTFILES
alias conf = cd $env.XDG_CONFIG_HOME
alias .. = cd ..
alias ... = cd ../..
alias .... = cd ../../..
alias ..... = cd ../../../..
alias ...... = cd ../../../../..
alias ......... = cd ../../../../../..
alias .......... = cd ../../../../../../..

alias macopen = ^open

def --wrapped fizz [...args: string] {
    ^fzf --preview 'bat -n -f {}' --preview-window=right:50%:wrap --ansi --height '40%' --border --prompt 'Search: ' ...$args
}

def uuid [] {
    let id = (random uuid | str lowercase)
    if (which pbcopy | is-not-empty) {
        $id | ^pbcopy
    } else if (which wl-copy | is-not-empty) {
        $id | ^wl-copy
    } else if (which xclip | is-not-empty) {
        $id | ^xclip -selection clipboard
    }
    $id
}

def --env wcd [] {
    let result = (^git wpick | complete)
    let dir = ($result.stdout | str trim)
    if $result.exit_code == 0 and ($dir | is-not-empty) {
        cd $dir
    }
}

if (which starship | is-not-empty) {
    mkdir ($nu.data-dir | path join 'vendor/autoload')
    starship init nu | save -f ($nu.data-dir | path join 'vendor/autoload/starship.nu')
}

if (which atuin | is-not-empty) {
    mkdir ($nu.data-dir | path join 'vendor/autoload')
    atuin init nu --disable-up-arrow | save -f ($nu.data-dir | path join 'vendor/autoload/atuin.nu')
}

if (which zoxide | is-not-empty) and ('DISABLE_ZOXIDE' not-in $env) {
    mkdir ($nu.data-dir | path join 'vendor/autoload')
    zoxide init nushell --cmd cd | save -f ($nu.data-dir | path join 'vendor/autoload/zoxide.nu')
}
