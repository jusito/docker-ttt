#!/bin/bash

sleep 5s
echo "starting entrypoint.sh"
set -e

cd "$STEAM_PATH"
#suggested -disableluarefresh -tickrate 66 +host_workshop_collection -port 27015

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

export parms="-game garrysmod +gamemode terrortown "$(printf "%s "  "$@")
if [ -e "${STEAM_PATH}/lgsm/config-lgsm/gmodserver/gmodserver.cfg" ]; then
	rm -f "${STEAM_PATH}/lgsm/config-lgsm/gmodserver/gmodserver.cfg"
fi
mkdir -p "${STEAM_PATH}/lgsm/config-lgsm/gmodserver/"
touch "${STEAM_PATH}/lgsm/config-lgsm/gmodserver/gmodserver.cfg"
echo "fn_parms(){" > "${STEAM_PATH}/lgsm/config-lgsm/gmodserver/gmodserver.cfg"
echo "parms="'"'"$parms"'"' >> "${STEAM_PATH}/lgsm/config-lgsm/gmodserver/gmodserver.cfg"
echo "}" >> "${STEAM_PATH}/lgsm/config-lgsm/gmodserver/gmodserver.cfg"
echo "starting with $parms"

trap 'pkill -15 srcds_linux' SIGTERM
#trap "cd ${STEAM_PATH} && ./gmodserver stop" SIGTERM
./gmodserver start
./gmodserver console &
wait "$!"
