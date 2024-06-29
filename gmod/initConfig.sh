#!/bin/bash

if [ "${DEBUGGING}" = "true" ]; then
	set -o xtrace
fi

set -o errexit
set -o nounset
set -o pipefail

CFG_PATH="${SERVER_PATH}/garrysmod/cfg/gmodserver.cfg"

function configReplace() {
    local source="$1"
    local target="$2"

    count=$(grep -Ece "^\s*${source}\s" "${CFG_PATH}")

    echo "[initConfig.sh]Request for replacing \"$source\" to \"$target\", source is found $count times"

    sed -E -i "/^\s${source}\s.*/d" "${CFG_PATH}"

    local file_ends_on_newline=$([ "$(tail -c1 f | wc -l)" -eq 1 ] && echo true || echo false)
    if ! $file_ends_on_newline; then
        echo "" >> "${CFG_PATH}"
    fi
    echo "$source \"$target\"" >> "${CFG_PATH}"
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
