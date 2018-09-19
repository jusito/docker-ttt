#!/bin/bash

echo "starting entrypoint.sh"
set -e

DEBUG_MODE=false
if [ "$1" = "testing" ]; then
	DEBUG_MODE=true
fi

echo "installing / updating steamcmd in $STEAM_PATH"
cd "$STEAM_PATH"
wget -q -O - "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar -zxvf -

if [ -e "${STEAM_PATH}/server/steam_cache" ]; then
	echo "clearing steam cache"
	rm -rf "${STEAM_PATH}/server/steam_cache/"
fi
if [ -e "${STEAM_PATH}/server/garrysmod/cache" ]; then
	echo "clearing cache"
	rm -rf "${STEAM_PATH}/server/garrysmod/cache/*"
fi

echo "testing steamcmd"
chmod ug=rwx,o= steamcmd.sh
./steamcmd.sh +login anonymous +quit

echo "installing / validating ttt"
cd "$STEAM_PATH"
./steamcmd.sh +login anonymous +force_install_dir "$STEAM_PATH/server/" +app_update 4020 validate +quit || \
	(echo '[error][1] catched => printing stderr.txt:' && \
		cat "Steam/logs/stderr.txt" && \
		echo '[error][1] <= printed' && \
		./steamcmd.sh +login anonymous +force_install_dir "$STEAM_PATH/server/" +app_update 4020 validate +quit) || \
	(echo '[error][2] catched => printing stderr.txt:' && \
		cat "Steam/logs/stderr.txt" && \
		echo '[error][2] <= printed' && \
		./steamcmd.sh +login anonymous +force_install_dir "$STEAM_PATH/server/" +app_update 4020 validate +quit)

echo "processing scripts before start"

echo "experimental.sh"
bash /home/experimental.sh
echo "forceWorkshopDownload.sh"
bash /home/forceWorkshopDownload.sh
echo "installAndMountAddons.sh"
bash /home/installAndMountAddons.sh


if [ -e "$SERVER_PATH/custom.sh" ]; then
	echo "existing: $SERVER_PATH/custom.sh"
	bash "$SERVER_PATH/custom.sh"
else
	echo "not existing: $SERVER_PATH/custom.sh"
fi

# todo catch => send killserver / quit
cd "$STEAM_PATH/server/"
trap 'pkill -15 srcds_run' SIGTERM

if [ "$DEBUG_MODE" != "true" ]; then
	chmod ug=rwx,o= srcds_run
	./srcds_run -console -game garrysmod +gamemode terrortown "$@" &
	wait "$!"
else
	echo "debug ended"
fi