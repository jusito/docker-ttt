#!/bin/bash

sleep 5s
echo "starting entrypoint.sh"
set -e



cd "$STEAM_PATH"

parms="-game garrysmod +gamemode terrortown "$(printf "%s "  "$@")
echo "starting with $parms"

ls -lA

if [ -e "${STEAM_PATH}/gmodserver" ]; then
	./gmodserver update-lgsm
	./gmodserver update
else
	bash linuxgsm.sh gmodserver
	./gmodserver auto-install
fi


trap './home/steam/gmodserver stop' SIGTERM
./gmodserver start
./gmodserver console
wait "$!"
