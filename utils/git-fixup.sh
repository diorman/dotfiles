#!/usr/bin/env bash

export FZF_DEFAULT_OPTS='--no-bold --color bg+:green,fg+:black,hl+:bold:black,hl:magenta,gutter:black,pointer:black,disabled:black --no-sort --no-multi --no-info --layout default --cycle --pointer " " --prompt " ❯ "'

fixup_mode=""
commit_options=()
number_commits=10
commit=""

while [[ $# -gt 0 ]]; do
  case $1 in
    --amend|--reword)
      fixup_mode="${1:2}:"
      shift
      ;;
    -a)
      commit_options+=("$1")
      shift
      ;;
    -n)
      number_commits="$2"
      shift
      shift
      ;;
    --help)
      echo 'Usage: git fixup [-a] [-n N] [--amend|--reword] [ref]'
      exit
      ;;
    *)
      commit="$1"
      shift
      ;;
  esac
done

if [[ -z "$commit" ]]; then
  commit=$(git log -n "$number_commits" --pretty=format:'%h %s' --no-merges | fzf | cut -c -7)
fi

if [[ -z "$commit" ]]; then
  exit 0
fi

git commit "${commit_options[@]}" --fixup "$fixup_mode$commit" && git -c sequence.editor=true rebase --interactive --autosquash "$commit~1"
