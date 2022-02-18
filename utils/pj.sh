#!/usr/bin/env bash

set -e

fatal() {
  >&2 echo "Error: $1"
  exit 1
}

main() {
  if [ -z "$1" ]; then
    fatal "key not given"
  fi

  local key
  IFS='/' read -ra key <<< "$1"

  local host="${PJ_DEFAULT_HOST:-"github.com"}"
  local user="${PJ_DEFAULT_USER:-$USER}"
  local project

  case ${#key[@]} in
    1)
      project="${key[0]}"
      ;;
    2)
      user="${key[0]}"
      project="${key[1]}"
      ;;
    3)
      host="${key[0]}"
      user="${key[1]}"
      project="${key[2]}"
      ;;
    *)
      fatal "invalid key"
  esac

  local directory="$CODEPATH/src/$host/$user/$project"

  if ! test -d "$directory"; then
    mkdir -p "$directory"
    trap 'rm -r "$directory"' ERR
    git clone "git@$host:$user/$project.git" "$directory"
  fi

  if ! kitty @ focus-tab --match cwd:"^$directory(/.+)?$" 2>/dev/null; then
    kitty @ launch --type tab --cwd "$directory" --no-response
  fi
}

main "$1"
