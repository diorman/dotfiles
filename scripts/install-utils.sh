#!/bin/sh

log_info() {
	printf "\r  [ \033[00;34mINFO\033[0m ] $1\n"
}

log_init() {
	printf "\r  [ \033[00;34m..\033[0m ] $1\n"
}

log_success() {
	printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

log_fail() {
	printf "\r\033[2K  [\033[0;31mFAIL\033[0m] $1\n"
}

link_file() {
	if [ -e "$2" ]; then
		if [ "$(readlink "$2")" == "$1" ]; then
			log_success "skipped $1"
			return 0
		else
			mv "$2" "$2.backup"
			log_success "moved $2 to $2.backup"
		fi
	fi
	ln -sf "$1" "$2"
	log_success "linked $1 to $2"
}
