#!/bin/bash

source .shlib/colors.lib
source .shlib/logging.lib
source .shlib/inipars.lib
source .shlib/operations.lib


if [[ $EUID -ne 0 ]]; then
  log.error "This script must be run as root." >&2
  log.sub "Please use sudo or log in as root."
  exit 1
fi


case $1 in
  start    ) start         ;;
  stop     ) stop          ;;
  theme    ) theme $2      ;;
  uninstall) uninstall     ;;
  *) usage && exit 1 ;;
esac