#!/bin/bash

sleep 5s
echo "starting entrypoint.sh"
set -e

cd "$STEAM_PATH"
#suggested -disableluarefresh -tickrate 66 +host_workshop_collection -port 27015
export parms="-game garrysmod +gamemode terrortown "$(printf "%s "  "$@")
#not needed I think: sed -i 's/parms=/#parms=/g' /home/steam/lgsm/config-lgsm/gmodserver/common.cfg
echo "starting with $parms"

if [ -e "${STEAM_PATH}/gmodserver" ]; then
	./gmodserver update-lgsm
	./gmodserver update
else
	bash linuxgsm.sh gmodserver
	./gmodserver auto-install
fi

cd "/home"
echo "check various options"
./experimental.sh
echo "force workshop download"
./forceWorkshopDownload.sh
echo "install & mount gamefiles"
./installAndMountAddons.sh
cd "$STEAM_PATH"

trap 'pkill -15 srcds_linux' SIGTERM
./gmodserver start
./gmodserver console
wait "$!"
