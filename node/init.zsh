#!/bin/zsh

if test -d $HOME/.nvm; then

  __nvm_init__() {
    # unset itself
    unset -f "${funcstack[1]}"

    # unset helper functions
    for cmd in nvm node npm npx; do
      unset -f "$cmd"
    done

    local nvm_dir="$HOME/.nvm"
    [ -s "$nvm_dir/nvm.sh" ] && \. "$nvm_dir/nvm.sh"  # This loads nvm
    [ -s "$nvm_dir/bash_completion" ] && \. "$nvm_dir/bash_completion" --no-use # This loads nvm bash_completion

    local node_version
    local nvmrc_path
    local nvmrc_node_version

    node_version="$(nvm version)"
    nvmrc_path="$(nvm_find_nvmrc)"

    if [ -n "$nvmrc_path" ]; then
      nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

      if [ "$nvmrc_node_version" = "N/A" ]; then
        nvm install
      elif [ "$nvmrc_node_version" != "$node_version" ]; then
        nvm use
      fi
    else
      nvm use default 1>/dev/null
    fi
  }

  for cmd in nvm node npm npx; do
    eval "$cmd() { __nvm_init__; command $cmd "\$@"; }"
  done
fi
