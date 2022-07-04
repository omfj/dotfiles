#!/usr/bin/env bash

blacklist=("i3" "neovim")

is_in_blacklist () {
  for blacklisted in blacklist[@]; then
    if [[ $1 -e $blacklisted ]]; then
      return true
    fi
  return false
}

if [[ -z $XDG_CONFIG_HOME ]]; then
  echo "XDG_CONFIG_HOME not set"
  exit 1
fi

# Loop over configs in the linux folder
for config in $(ls linux/);
do
  is_blacklisted=$(is_in_blacklist ) 
  if [[ -f "$XDG_CONFIG_HOME/$config"]]; then
    echo "Config for $config already exists."
  elif [[ is_blacklisted $config ]]; then
    echo "Skipping $config..."
  else
    ln -s "$(pwd)/linux/$config" "$XDG_CONFIG_HOME/$config"
  fi
done

echo "All config files have been symlinked"
