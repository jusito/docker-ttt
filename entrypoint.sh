#!/bin/bash

echo "starting entrypoint.sh"
set -e

echo "installing / updating steamcmd in $STEAM_PATH"
cd "$STEAM_PATH"
wget -q -O - "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar -zxvf -

echo "testing steamcmd"
./steamcmd.sh -noasync +login anonymous +quit

echo "installing / validating ttt"
cd "$STEAM_PATH"
./steamcmd.sh -noasync +login anonymous +force_install_dir "$STEAM_PATH/server/" +app_update 4020 validate +quit

# todo catch => send killserver / quit
cd "$STEAM_PATH/server/"
trap 'pkill -15 srcds_run' SIGTERM

#-console -game garrysmod +gamemode terrortown
echo "starting with"
echo "$@"
echo $@
./srcds_run "$@" &
wait "$!"
