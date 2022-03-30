#!/usr/bin/env bash

set -e

fatal() {
  >&2 echo "Error: $1"
  exit 1
}

repository_url() {
  if [[ "$1" =~ ^(git@|https?://) ]]; then
    echo "$1"
    return
  fi

  local list
  IFS='/' read -ra list <<< "$1"

  local host="${GIT_DEFAULT_HOST:-"github.com"}"
  local user="${GIT_DEFAULT_USER:-$USER}"
  local project

  case ${#list[@]} in
    1)
      project="${list[0]}"
      ;;
    2)
      user="${list[0]}"
      project="${list[1]}"
      ;;
    3)
      host="${list[0]}"
      user="${list[1]}"
      project="${list[2]}"
      ;;
    *)
      fatal "invalid parameter"
  esac

  echo "git@$host:$user/$project.git"
}

directory_from_url() {
  local path
  path=$(echo "$1" | sed -r 's/^(git@|https:\/\/)(.*)(:|\/)(.*)\/(.*)\.git$/\2\/\4\/\5/')
  echo "$CODEPATH/$path"
}

main() {
  local url
  local dir

  url=$(repository_url "$1")
  dir=$(directory_from_url "$url")

  if test -d "$dir"; then
    fatal "directory already exists -> $dir"
  fi

  mkdir -p "$dir"
  trap 'rm -r "$dir"' ERR
  git clone "$url" "$dir"
}

main "$1"
