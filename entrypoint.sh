#!/bin/bash
echo "starting entrypoint.sh"
set -e

echo "installing / updating steamcmd"
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

bash experimental.sh
bash installAndMountAddons.sh
bash forceWorkshopDownload.sh

echo "processing scripts before start"
if [ -e "$SERVER_PATH/custom.sh" ]; then
	echo "existing: $SERVER_PATH/custom.sh"
	bash "$SERVER_PATH/custom.sh"
else
	echo "not existing: $SERVER_PATH/custom.sh"
fi

# todo catch => send killserver / quit
cd "$STEAM_PATH/server/"
trap 'pkill -15 srcds_run' SIGTERM
./srcds_run -console -game garrysmod +gamemode terrortown "$@" &
wait "$!"