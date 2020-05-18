#!/bin/bash

set -e

# shellcheck disable=SC1090
source "$DOTFILES/utils.sh"

JAVA_JENV_VERSIONS=(1.8 11.0)
JAVA_SDK_PATHS=(jdk1.8.0_162.jdk openjdk-11.0.2.jdk)
JAVA_DEFAULT_VERSION=1.8

for index in "${!JAVA_JENV_VERSIONS[@]}"; do
  java_version="${JAVA_JENV_VERSIONS[$index]}"
  java_path="/Library/Java/JavaVirtualMachines/${JAVA_SDK_PATHS[$index]}/Contents/Home"
  log_info "checking java $java_version installation..."

  if ! jenv versions | grep "$java_version" > /dev/null; then
    echo "adding $java_version to jenv..."
    jenv add "$java_path"
  fi

  log_info "jvm $java_version"
done

jenv global $JAVA_DEFAULT_VERSION
