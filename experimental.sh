#!/bin/bash

set -e

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

#create default server.config
# not empty: grep -q '[^[:space:]]' < 'server.cfg' && echo "not empty"
if [ ! -e "${SERVER_PATH}/garrysmod/cfg/server.cfg" ] || [ "0" = "$(grep -o '[^[:space:]]' "${SERVER_PATH}/garrysmod/cfg/server.cfg" | wc -l)" ]; then
	mkdir -p "${SERVER_PATH}/garrysmod/cfg"
	wget -O "${SERVER_PATH}/garrysmod/cfg/server.cfg" "https://raw.githubusercontent.com/jusito/docker-ttt/master/server.cfg"
	chown "$USER_ID:$GROUP_ID" "${SERVER_PATH}/garrysmod/cfg/server.cfg"
	chmod u+rw "${SERVER_PATH}/garrysmod/cfg/server.cfg"
fi

#set hostname & password, working if only one entry is in
if [ -n "${SERVER_NAME}" ]; then
	configReplace "hostname" "$SERVER_NAME"
fi
if [ -n "${SERVER_PASSWORD}" ]; then
	configReplace "sv_password" "$SERVER_PASSWORD"
fi
if [ -n "${SERVER_VOICE_ENABLE}" ]; then
	configReplace "sv_voiceenable" "$SERVER_VOICE_ENABLE"
fi

#this is a simple option for myself, but you can use it too
if [ "$USE_MY_REPLACER_CONFIG" = "true" ] && [ ! -e "${SERVER_PATH}/garrysmod/data/jusito_ttt_entity_replace" ]; then
	mkdir -p "${SERVER_PATH}/garrysmod/data/jusito_ttt_entity_replace"
	wget -O "${SERVER_PATH}/garrysmod/data/jusito_ttt_entity_replace/config.txt" "https://raw.githubusercontent.com/jusito/ttt_entity_replace/master/config.txt.example_fas2"
fi

