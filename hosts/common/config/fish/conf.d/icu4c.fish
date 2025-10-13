# Adds icu4c@77 to the PATH if it is installed via Homebrew on macOS.
# This is needed for texlive to find the icu4c libraries.

if test -d /opt/homebrew/opt/icu4c@77/bin
    fish_add_path /opt/homebrew/opt/icu4c@77/bin
end

if test -d /opt/homebrew/opt/icu4c@77/sbin
    fish_add_path /opt/homebrew/opt/icu4c@77/sbin
end

if test -d /opt/homebrew/opt/icu4c@76/bin
  fish_add_path /opt/homebrew/opt/icu4c@76/bin
  fish_add_path /opt/homebrew/opt/icu4c@76/sbin

  set -gx LDFLAGS "-L/opt/homebrew/opt/icu4c@76/lib"
  set -gx CPPFLAGS "-I/opt/homebrew/opt/icu4c@76/include"

  set -gx PKG_CONFIG_PATH "/opt/homebrew/opt/icu4c@76/lib/pkgconfig"
end

