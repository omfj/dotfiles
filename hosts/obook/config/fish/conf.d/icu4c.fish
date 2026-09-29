# Retain both ICU versions to match the current zsh setup.
if test -d /opt/homebrew/opt/icu4c@77/bin
    fish_add_path --path /opt/homebrew/opt/icu4c@77/bin /opt/homebrew/opt/icu4c@77/sbin
end
if test -d /opt/homebrew/opt/icu4c@76/bin
    fish_add_path --path /opt/homebrew/opt/icu4c@76/bin /opt/homebrew/opt/icu4c@76/sbin
    set -gx LDFLAGS "-L/opt/homebrew/opt/icu4c@76/lib"
    set -gx CPPFLAGS "-I/opt/homebrew/opt/icu4c@76/include"
    set -gx PKG_CONFIG_PATH /opt/homebrew/opt/icu4c@76/lib/pkgconfig
end
