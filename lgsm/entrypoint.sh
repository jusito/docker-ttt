#!/bin/bash

if [ "${DEBUGGING}" = "true" ]; then
	set -o xtrace
fi

set -o errexit
set -o pipefail

echo "starting entrypoint.sh"
set -e






# --- Install / Update ---
cd "$STEAM_PATH"
if [ -n "$SERVER_EXECUTABLE" ] && [ -e "${STEAM_PATH}/$SERVER_EXECUTABLE" ]; then
	./"$SERVER_EXECUTABLE" update-lgsm
	./"$SERVER_EXECUTABLE" update
else
	bash linuxgsm.sh "$SERVER_GAME"
	./"$SERVER_EXECUTABLE" auto-install
fi

if [ -e "/home/prepareServer.sh" ]; then
	cd /home
	./prepareServer.sh
	cd "$STEAM_PATH"
fi






# --- Apply LGSM Workarounds ---
#force fetch of command_console.sh
if [ ! -e "${STEAM_PATH}/lgsm/functions/command_console.sh" ]; then
	wget -O "${STEAM_PATH}/lgsm/functions/command_console.sh" "https://raw.githubusercontent.com/GameServerManagers/LinuxGSM/master/lgsm/functions/command_console.sh"
	chmod +x "${STEAM_PATH}/lgsm/functions/command_console.sh"
fi
#skip confirmation
sed -i 's/! fn_prompt_yn "Continue?" Y/[ "1" != "1" ]/' "${STEAM_PATH}/lgsm/functions/command_console.sh"





# --- Start Server ---
#start server
IS_RUNNING="true"
function stopServer() {
	echo "stopping server..."
	cd "${STEAM_PATH}"
	pid=$(pidof "$SERVER_EXECUTABLE")
	kill -2 "$pid" || true
	echo "server stopped!"
	echo "stopping entrypoint..."
	IS_RUNNING="false"
}
./"$SERVER_EXECUTABLE" start
trap stopServer SIGTERM

#start cron
bash "/home/initCron.sh"





# --- Wait for Shutdown ---
echo "Server is running, waiting for SIGTERM"
while [ "$IS_RUNNING" = "true" ]
do
	sleep 1s
done
echo "entrypoint stopped"
exit 0