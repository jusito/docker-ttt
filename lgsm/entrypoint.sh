#!/bin/bash

if [ "${DEBUGGING}" = "true" ]; then
	set -o xtrace
fi

set -o errexit
set -o nounset
set -o pipefail

echo "[entrypoint.sh]starting entrypoint.sh"
set -e






# --- Install / Update ---
cd "$STEAM_PATH"
if [ -n "$SERVER_EXECUTABLE" ] && [ -e "${STEAM_PATH}/$SERVER_EXECUTABLE" ] && [ -d "$STEAM_CMD" ]; then
	echo "[entrypoint.sh]updating..."
	if "$LGSM_UPDATE"; then
		./"$SERVER_EXECUTABLE" update-lgsm | (
			# this sometimes prevent updating, I dont get it why this is an issue
			rm -rf "${STEAM_PATH}/lgsm/functions/lgsm"
			./"$SERVER_EXECUTABLE" update-lgsm
		)
	fi
	./"$SERVER_EXECUTABLE" update
else
	echo "[entrypoint.sh]installing..."
	bash linuxgsm.sh "$SERVER_GAME"
	./"$SERVER_EXECUTABLE" auto-install
fi
echo "[entrypoint.sh]update / installation done!"

if [ -e "/home/prepareServer.sh" ]; then
	cd /home
	./prepareServer.sh "$@"
	cd "$STEAM_PATH"
fi






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
	echo "done!"
}
./"$SERVER_EXECUTABLE" start &
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