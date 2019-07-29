#!/bin/sh

if [ "${DEBUGGING}" = "true" ]; then
	set -o xtrace
fi

set -o errexit
set -o nounset
#./prepareServer.sh: 9: set: Illegal option -o pipefail
#set -o pipefail

mkdir -p "/home/steam/lgsm/config-lgsm/gmodserver/"
cp -f "/home/common.cfg" "/home/steam/lgsm/config-lgsm/gmodserver/common.cfg"

cd "/home"
echo "check configurations"
./initConfig.sh
echo "force workshop download"
./forceWorkshopDownload.sh
echo "install & mount gamefiles"
./installAndMountAddons.sh
cd "$STEAM_PATH"

#docker args -> lgsm args
temp=""
temp=$(printf "%s "  "$@") || true
export parms="-game garrysmod $SERVER_GAMEMODE $temp"
if [ -e "${STEAM_PATH}/lgsm/config-lgsm/gmodserver/gmodserver.cfg" ]; then
	rm -f "${STEAM_PATH}/lgsm/config-lgsm/gmodserver/gmodserver.cfg"
fi
mkdir -p "${STEAM_PATH}/lgsm/config-lgsm/gmodserver/"
touch "${STEAM_PATH}/lgsm/config-lgsm/gmodserver/gmodserver.cfg"
echo "fn_parms(){" > "${STEAM_PATH}/lgsm/config-lgsm/gmodserver/gmodserver.cfg"
echo "parms="'"'"$parms"'"' >> "${STEAM_PATH}/lgsm/config-lgsm/gmodserver/gmodserver.cfg"
echo "}" >> "${STEAM_PATH}/lgsm/config-lgsm/gmodserver/gmodserver.cfg"
echo "starting with $parms"