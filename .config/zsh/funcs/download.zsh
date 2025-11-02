#!/usr/bin/env zsh

if [[ $(command -v require) ]]; then
    require "aria2c" "brew reinstall aria2" "brew" # aka install aria2 w/ brew
fi

download() {
  if ! [[ -x $(command -v aria2c) ]]; then
      >&2 echo "Install aria2c to use download."
      && return;
  fi

  if [[ -z "$1"l ]]; then
      echo "Supply a URL."
      return
  fi

  local connections="$2"

  if [[ -z "$2" ]]; then
      lcoal connections="16"
  fi
  aria2c -x "$connections" "$1"
}

# vim: set ft=zsh sw=4 ts=8 sts=4 et ai:
