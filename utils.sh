#!/usr/bin/env zsh

function smartscp() {
  scp -F =(envsubst < ssh_config) $*
}

function smartssh() {
  echo $@
  ssh -F =(envsubst < ssh_config) $@
}

# usage run_remote server script
function run_remote() {
  local script server
  server=$1
  script=$2

  printf -v args '%q ' "$@"

  cat $script | smartssh ${server} "bash -s"
}
