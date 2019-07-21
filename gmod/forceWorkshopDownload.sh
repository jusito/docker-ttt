#!/bin/bash

if [ "${DEBUGGING}" = "true" ]; then
	set -o xtrace
fi

set -o errexit
set -o nounset
set -o pipefail

#using WORKSHOP_COLLECTION_ID
LUA_PATH="${SERVER_PATH}/garrysmod/lua/autorun/server"
LUA_FILE="${LUA_PATH}/workshop_autoload.lua"

#remove old file
if [ -e "$LUA_FILE" ]; then
	rm "$LUA_FILE"
else
	mkdir -p "$LUA_PATH"
fi

if [ "$WORKSHOP_COLLECTION_ID" = "0" ] || [ "$WORKSHOP_COLLECTION_ID" = "" ]; then
	echo "given ID is default, no workshop download"
else
	touch "$LUA_FILE"
	arr=$(wget -q -O - https://steamcommunity.com/sharedfiles/filedetails/?id="${WORKSHOP_COLLECTION_ID}" | tr '\n' ' ' | grep -Po '"workshopItem"[^"]+"https://steamcommunity.com/sharedfiles/filedetails/\?id=(\d+)' | grep -Po '\d\d\d+' )
	str=""
	for i in "${arr[@]}"
	do
		str=${str}"resource.AddWorkshop( \"${i}\" )"$'\n'
	done
	echo "$str" > "$LUA_FILE"
fi

