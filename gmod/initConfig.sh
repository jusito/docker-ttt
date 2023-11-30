#!/bin/bash

if [ "${DEBUGGING}" = "true" ]; then
	set -o xtrace
fi

set -o errexit
set -o nounset
set -o pipefail

CFG_PATH="${SERVER_PATH}/garrysmod/cfg/gmodserver.cfg"

function configReplace() {
	source="$1"
	target="\"$2\""
	
	count=$(grep -Poc "($source).+" "${CFG_PATH}" || echo 0)
	
	echo "[initConfig.sh]Request for replacing $source to $target, source is found $count times"
	
	if [ "$count" == "1" ]; then
		sed -Ei "/${source}.*/d" "${CFG_PATH}"
		echo "$source $target" >> "${CFG_PATH}"
		
	elif [ "$count" == "0" ]; then
		echo "" >> "${CFG_PATH}"
		echo "$source $target" >> "${CFG_PATH}"
		
	else
		echo "[initConfig.sh]can't set $1 because there are multiple in"
	fi
}

#create default server.config
# not empty: grep -q '[^[:space:]]' < 'server.cfg' && echo "not empty"
if [ ! -e "${CFG_PATH}" ] || [ "0" = "$(grep -oc '[^[:space:]]' "${CFG_PATH}")" ]; then
	mkdir -p "${SERVER_PATH}/garrysmod/cfg" || true
	cp -f "/home/server.cfg.default" "${CFG_PATH}"
	chown "$USER_ID:$GROUP_ID" "${CFG_PATH}"
	chmod u+rw "${CFG_PATH}"
fi

# set hostname & password, working if only one entry is in
if [ -n "${SERVER_NAME}" ]; then
	configReplace "hostname" "$SERVER_NAME"
fi
if [ -n "${SERVER_PASSWORD}" ]; then
	configReplace "sv_password" "$SERVER_PASSWORD"
fi
if [ -n "${SERVER_RCON_PASSWORD}" ]; then
	configReplace "rcon_password" "$SERVER_RCON_PASSWORD"
fi
if [ -n "${SERVER_VOICE_ENABLE}" ]; then
	configReplace "sv_voiceenable" "$SERVER_VOICE_ENABLE"
fi