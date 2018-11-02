#!/bin/bash

sleep 2s
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

#docker args -> lgsm args
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

#force fetch of command_console.sh
if [ ! -e "${STEAM_PATH}/lgsm/functions/command_console.sh" ]; then
	wget -O "${STEAM_PATH}/lgsm/functions/command_console.sh" "https://raw.githubusercontent.com/GameServerManagers/LinuxGSM/master/lgsm/functions/command_console.sh"
	chmod +x "${STEAM_PATH}/lgsm/functions/command_console.sh"
fi
#skip confirmation
sed -i 's/! fn_prompt_yn "Continue?" Y/[ "1" != "1" ]/' "${STEAM_PATH}/lgsm/functions/command_console.sh"

#start server
IS_RUNNING="true"
function stopServer {
	echo "stopping server..."
	cd "${STEAM_PATH}"
	pkill -2 srcds_linux
	pkill -2 srcds_run
	echo "server stopped!"
	echo "stopping entrypoint..."
	IS_RUNNING="false"
}
./gmodserver start
trap stopServer SIGTERM
echo "Server is running, waiting for SIGTERM"
while [ "$IS_RUNNING" = "true" ]
do
	sleep 1s
done
echo "entrypoint stopped"
exit 0