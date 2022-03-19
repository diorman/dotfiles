#!/usr/bin/env bash

set -e

fatal() {
  >&2 echo "Error: $1"
  exit 1
}

switch() {
  local result
  local window_id="$__PREVIOUS_KITTY_WINDOW_ID"
  result=$(tab-tree | finder --layout=reverse-list --disabled --no-info --prompt '' || true)

  if [ -n "$result" ]; then
    window_id=$(echo "$result" | sed -r 's/.*\[(.*)\]$/\1/')
  fi

  if [ -n "$window_id" ]; then
    kitty @ focus-window --match "id:$window_id" --no-response
  fi
}

open_tab_dir() {
  local dir="${1%"/"}"
  local session_id="$2"

  if ! test -d "$dir"; then
    fatal "directory does not exist -> $dir"
  fi

  local match="cwd:^$dir$"
  local extra_opts=()

  if [ -n "$session_id" ]; then
    match="env:__SESSION_ID=$session_id"
    extra_opts=(--env "__SESSION_ID=$session_id")
  fi

  if ! kitty @ focus-tab --match "$match" 2>/dev/null; then
    kitty @ launch --type tab --cwd "$dir" --no-response "${extra_opts[@]}"
  fi
}

open_tab_project() {
  local result
  local dir
  result=$(find "$CODEPATH/src/" -mindepth 3 -maxdepth 3 -type d | sed "s|$CODEPATH/src/||" | finder --print-query || true)
  result_length="$(echo "$result" | wc -l)"


  if [ "$result_length" -eq 2 ]; then
    dir="$CODEPATH/src/$(echo "$result" | tail -n 1)"
  elif [ -n "$result" ]; then
    dir=$(git-get "$result" | head -n 1 | sed -r "s/Cloning into '(.*)'.../\1/")
  fi

  if [ -n "$dir" ]; then
    open_tab_dir "$dir" "$(echo "$dir" | sed -r 's|.*/(.*)/(.*)$|\1/\2|')"
    return
  fi

  if [ -n "$__PREVIOUS_KITTY_WINDOW_ID" ]; then
    kitty @ focus-window --match "id:$__PREVIOUS_KITTY_WINDOW_ID" --no-response
  fi
}

finder() {
  fzf --no-bold --color bg+:green,fg+:black,hl+:bold:black,hl:magenta,gutter:black,pointer:black,disabled:black --no-info --pointer '=>' "$@"
}

main() {
  case "$1" in
    switch)
      switch
      ;;
    open-dir)
      open_tab_dir "$2" "$3"
      ;;
    open-project)
      open_tab_project
      ;;
    *)
      fatal "subcommands: open-dir | open-project | switch"
  esac
}

main "$@"

