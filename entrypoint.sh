#!/bin/bash

echo "starting entrypoint.sh"
set -e


parms="-game garrysmod +gamemode terrortown "$(printf "%s "  "$@")
echo "starting with $parms"
./gmodserver install

trap './home/steam/gmodserver stop' SIGTERM
./gmodserver debug
wait "$!"
