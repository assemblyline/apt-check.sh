#!/bin/sh

set -e

parse_options() {
  local OPTIND
  while getopts ":hfqsc" opt; do
    case $opt in
      h) HUMAN_READABLE=1;;
      f) FUSSY=1;;
      q) QUIET=1;;
      s) SKIP_UPDATE=1;;
      c) CLEANUP=1;;
    esac
  done
}

update() {
  if [ -z "$SKIP_UPDATE" ]; then
    apt-get update > /dev/null 2>&1
  fi
}

SECURITY_LIST=/tmp/apt-check.sh-fs6s6dfsf-security.list

security_upgrades() {
  grep security /etc/apt/sources.list > $SECURITY_LIST;
  if [ -s "$SECURITY_LIST" ]; then
    apt-get upgrade -oDir::Etc::Sourcelist=$SECURITY_LIST -s
  fi
  rm -f $SECURITY_LIST
}

cleanup() {
  if [ -n "$CLEANUP" ]; then
    apt-get clean
    rm -rf /var/lib/apt/lists/*
  fi
}

all_upgrades() {
  apt-get upgrade -s
}

count_upgrades() {
  grep 'upgraded,' | cut -d ' ' -f 1
}


collect_info() {
  SECURITY=`security_upgrades | count_upgrades`
  ALL=`all_upgrades | count_upgrades`
}

echo_info() {
  if [ -n "$HUMAN_READABLE" ]; then
    echo "${ALL} packages can be updated." >&2
    if [ -n "$SECURITY" ]; then
      echo "${SECURITY} updates are security updates." >&2
    fi
  else
    if [ -n "$SECURITY" ]; then
      echo "${ALL};${SECURITY}" >&2
    else
      echo "${ALL}" >&2
    fi
  fi
}

output_info() {
  if ! updates_count; then
    echo_info
  else
    if [ -z "$QUIET" ]
    then
      echo_info
    fi
  fi
}


updates_count() {
 if [ -n "$FUSSY" ]; then
   return $ALL
 else
   if [ -n "$SECURITY" ]; then
     return $SECURITY
   else
     return $ALL
   fi
 fi
}

exit_appropriately() {
  updates_count
  exit
}

parse_options $@
update
collect_info
output_info
cleanup
exit_appropriately
