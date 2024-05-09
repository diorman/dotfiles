#!/usr/bin/env bash

export FZF_DEFAULT_OPTS='--select-1 --no-bold --color bg+:green,fg+:black,hl+:bold:black,hl:magenta,gutter:black,pointer:black,disabled:black --no-sort --no-multi --no-info --layout default --cycle --pointer " " --prompt " ❯ "'

query=""
git_branch_options=()

while [[ $# -gt 0 ]]; do
  case $1 in
    -r|-a)
      git_branch_options+=("$1")
      shift
      ;;
    --help)
      echo 'Usage: git fuzzy-switch [-r|-a] [query]'
      exit
      ;;
    *)
      query="$1"
      shift
      ;;
  esac
done

# do a git fetch if listing remote branches
if [[ "${git_branch_options[@]}" =~ "-a" || "${git_branch_options[@]}" =~ "-r" ]]; then
  git fetch > /dev/null
fi

git branch "${git_branch_options[@]}" --format '%(refname:short)|%(committerdate:relative)' --sort -committerdate |
  grep -v '^origin|' | # removes entry named "origin"
  column -t -s '|' |
  fzf --query "$query" |
  cut -d ' ' -f 1 |
  sed 's/^origin\///' | # removes "origin/" prefix from remote branches
  xargs -ro git switch
