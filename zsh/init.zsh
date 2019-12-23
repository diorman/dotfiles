#!/bin/zsh

###################################################
## FPATH
###################################################

if [[ "$(ls -A $DOTFILES/functions)" ]]; then
	fpath=("$DOTFILES/functions" $fpath)
	autoload -U "$DOTFILES"/functions/*(:t)
fi

typeset -U fpath

###################################################
## COLORS
###################################################

# makes color constants available
autoload -U colors
colors

###################################################
## HISTORY
###################################################

HISTFILE=~/.zhistory
HISTSIZE=10000
SAVEHIST=10000

###################################################
## KEYBINDINGS
###################################################

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
bindkey "^P" history-search-backward
bindkey "^Y" accept-and-hold
bindkey "^N" insert-last-word
bindkey "^Q" push-line-or-edit
bindkey -s "^T" "^[Isudo ^[A" # "t" for "toughguy"

###################################################
## OPTIONS
###################################################

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

###################################################
## COMPLETION
###################################################

# forces zsh to realize new commands
zstyle ':completion:*' completer _oldlist _expand _complete _match _ignored _approximate

# matches case insensitive for lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# pasting with tabs doesn't perform completion
zstyle ':completion:*' insert-tab pending

# rehash if command not found (possibly recently installed)
zstyle ':completion:*' rehash true

# menu if nb items > 2
zstyle ':completion:*' menu select=2

zstyle ":completion:*:descriptions" format "%B%d%b"
