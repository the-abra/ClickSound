#!/bin/bash

source .shlib/colors.lib
source .shlib/logging.lib
source .shlib/operations.lib
source .shlib/inipars.lib

if [[ $EUID -ne 0 ]]; then
  log.error "This script must be run as root." >&2
  log.sub "Please use sudo or log in as root."
  exit 1
fi


while getopts "start:stop:theme:uninstall" opt; do
  case $opt in
    start    ) start         ;;
    stop     ) stop          ;;
    theme    ) theme $OPTARG ;;
    uninstall) uninstall     ;;
    *) usage && exit 1 ;;
  esac
done
