## FPATH
for profile in ${(z)NIX_PROFILES}; do
  fpath+=($profile/share/zsh/site-functions $profile/share/zsh/$ZSH_VERSION/functions $profile/share/zsh/vendor-completions)
done

fpath+=( "$HOME/.zsh_functions" )
autoload -U $HOME/.zsh_functions/*(:t)

## HISTORY
HISTFILE="$HOME/.zhistory"
HISTSIZE=10000
SAVEHIST=10000

## KEYBINDINGS

# give us access to ^Q
stty -ixon

# vi mode
bindkey -v
bindkey "^F" vi-cmd-mode

# handy keybindings
bindkey "^A" beginning-of-line
bindkey "^E" end-of-line
bindkey "^K" kill-line
bindkey "^R" history-incremental-search-backward
bindkey "^S" history-incremental-search-forward
bindkey "^P" history-search-backward
bindkey "^Y" accept-and-hold
bindkey "^N" insert-last-word
bindkey "^Q" push-line-or-edit

## OPTIONS
setopt EXTENDED_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_DUPS
setopt HIST_VERIFY
setopt INC_APPEND_HISTORY

setopt EXTENDED_GLOB
setopt NO_BEEP
setopt NO_LIST_BEEP
setopt PROMPT_SUBST
unsetopt NOMATCH

## PLUGINS
source "${NIX_PROFILE_DIRECTORY}/etc/antibody/plugins.sh"
