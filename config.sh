#!/bin/bash

set -e

#create default server.config
if [ ! -e "${SERVER_PATH}/garrysmod/cfg/server.cfg" ] || [ "0" = "$(grep -o '[^[:space:]]' "${SERVER_PATH}/garrysmod/cfg/server.cfg" | wc -l)" ]; then
	mkdir -p "${SERVER_PATH}/garrysmod/cfg"
	wget -O "${SERVER_PATH}/garrysmod/cfg/server.cfg" "https://raw.githubusercontent.com/jusito/docker-ttt/master/server.cfg"
	chown "$USER_ID:$GROUP_ID" "${SERVER_PATH}/garrysmod/cfg/server.cfg"
	chmod u+rw "${SERVER_PATH}/garrysmod/cfg/server.cfg"
fi

#set hostname & password, working if only one entry is in
function configReplace() {
	source="$1"
	target="$source \"$2\""
	count=$(grep -Po "($source).+" "${SERVER_PATH}/garrysmod/cfg/server.cfg" | wc -l)
	
	echo "Request for replacing $source to $target, source is found $count times"
	
	if [ "$count" == "1" ]; then
		source=$(grep -Po "($source).+" "${SERVER_PATH}/garrysmod/cfg/server.cfg" | sed 's/\\/\\\\/g' | sed 's/\//\\\//g')
		target=$(echo "$target" | sed 's/\\/\\\\/g' | sed 's/\//\\\//g')
		sed -i "s/$source/$target/g" "${SERVER_PATH}/garrysmod/cfg/server.cfg"
	elif [ "$count" == "0" ]; then
		echo "" >> "${SERVER_PATH}/garrysmod/cfg/server.cfg"
		echo "$target" >> "${SERVER_PATH}/garrysmod/cfg/server.cfg"
	else
		echo "can't set $1 because there are multiple in"
	fi
}
if [ -n "${SERVER_NAME}" ]; then
	configReplace "hostname" "$SERVER_NAME"
fi
if [ -n "${SERVER_PASSWORD}" ]; then
	configReplace "sv_password" "$SERVER_PASSWORD"
fi
if [ -n "${SERVER_VOICE_ENABLE}" ]; then
	configReplace "sv_voiceenable" "$SERVER_VOICE_ENABLE"
fi

#this is a simple option for one of my mods, but you can use it too
if [ "$USE_MY_REPLACER_CONFIG" = "true" ] && [ ! -e "${SERVER_PATH}/garrysmod/data/jusito_ttt_entity_replace" ]; then
	mkdir -p "${SERVER_PATH}/garrysmod/data/jusito_ttt_entity_replace"
	wget -O "${SERVER_PATH}/garrysmod/data/jusito_ttt_entity_replace/config.txt" "https://raw.githubusercontent.com/jusito/ttt_entity_replace/master/config.txt.example_fas2"
fi

echo "force workshop download"
./home/forceWorkshopDownload.sh
echo "install & mount gamefiles"
./home/installAndMountAddons.sh
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
