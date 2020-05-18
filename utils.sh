#!/bin/bash

log_info() {
  printf "\r[ \033[00;34mINFO\033[0m ] %s\n" "$1"
}

log_fail() {
  printf "\r\033[2K[ \033[0;31mFAIL\033[0m ] %s\n" "$1"
}

link_file() {
  if [ -e "$2" ]; then
    if [ "$(readlink "$2")" == "$1" ]; then
      log_info "skipped creating link for $1"
      return 0
    else
      log_info "moving file $2 to $2.backup"
      mv "$2" "$2.backup"
    fi
  fi

  log_info "linking $1 to $2"
  ln -sf "$1" "$2"
}

in_array() {
  local entry="$1"
  shift
  local list=("$@")

  for e in "${list[@]}"; do
    if [ "$e" = "$entry" ]; then return; fi
  done

  return 1
}
