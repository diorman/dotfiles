#!/bin/sh

set -e

git_get_log_error() {
	>&2 echo "ERROR: $1"
}

git_get_log_info() {
	>&2 echo "INFO: $1"
}

git_get_count_url_parts() {
	local slashes="${1//[^\/]}"
	echo $((${#slashes} + 1))
}

git_get_to_canonical_url() {
	local repo="$1"
	repo=${repo#"https://"}
	repo=${repo#"http://"}
	repo=${repo#"git@"}
	repo=${repo%".git"}
	repo=${repo/":"/"/"}

	local default_host=${GIT_GET_DEFAULT_HOST:-"github.com"}

	if [[ $(git_get_count_url_parts $repo) -eq 1 && -n $GIT_GET_DEFAULT_ORG ]]; then
		repo="$GIT_GET_DEFAULT_ORG/$repo"
	fi

	if [ $(git_get_count_url_parts $repo) -eq 2 ]; then
		repo="$default_host/$repo"
	fi

	echo $repo
}

git_get_to_git_url() {
	echo $(echo "$1" | awk '{ split($0,a,"/"); printf "git@%s:%s/%s.git",a[1],a[2],a[3] }')
}

git_get_main() {
	if [ -z ${1} ]; then
		git_get_log_error "repository address not given"
		return 1
	fi

	local repo="$1"
	local canonical_url=$(git_get_to_canonical_url $repo)
	local dest="${GIT_GET_PATH:-"$HOME/Projects/src"}/$canonical_url"
	local clone_url=$(git_get_to_git_url $canonical_url)

	if test -d $dest; then
		git_get_log_info "destination path already exists: $dest. Skipping cloning"
	else
		mkdir -p $dest
		git clone $clone_url $dest || rm -rf $dest
	fi
}

git_get_dest() {
	local repo="$1"
	local canonical_url=$(git_get_to_canonical_url $repo)
	echo "${GIT_GET_PATH:-"$HOME/Projects/src"}/$canonical_url"
}

git_get_cleanup() {
	for fn in "git_get_main" \
		"git_get_log_error" \
		"git_get_log_info" \
		"git_get_count_url_parts" \
		"git_get_to_canonical_url" \
		"git_get_cleanup" \
    "git_get_dest" \
		"git_get_to_git_url"; do

		unset -f "$fn"
	done
}
