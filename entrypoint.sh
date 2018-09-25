#!/bin/bash

echo "starting entrypoint.sh"
set -e


parms=

./gmodserver install

trap './home/steam/gmodserver stop' SIGTERM
./gmodserver debug
wait "$!"
