#!/bin/bash

set -e

mount='"mountcfg"'$'\n{\n'
if [ "$INSTALL_CSS" = "true" ]; then
	echo "installing & mounting css"
	./steamcmd.sh +login anonymous +force_install_dir "$CSS_PATH" +app_update 232330 validate +quit
	mount=${mount}'        "cstrike"    "'"${CSS_PATH}/cstrike"'"\n'
	if [ "$INSTALL_HL2" != "true" ]; then
		mount=${mount}'        "hl2"    "'"${CSS_PATH}/hl2"'"\n'
	fi
fi
if [ "$INSTALL_HL2" = "true" ]; then
	echo "installing & mounting hl2"
	./steamcmd.sh +login anonymous +force_install_dir "$HL2_PATH" +app_update 232370 validate +quit
	mount=${mount}'        "hl2"    "'"${HL2_PATH}/hl2"'"\n'
	mount=${mount}'        "hl2mp"    "'"${HL2_PATH}/hl2mp"'"\n'
fi
if [ "$INSTALL_TF2" = "true" ]; then
	echo "installing & mounting tf2"
	./steamcmd.sh +login anonymous +force_install_dir "$TF2_PATH" +app_update 232250 validate +quit
	mount=${mount}'        "tf2"    "'"${TF2_PATH}/tf"'"\n'
	if [ "$INSTALL_CSS" != "true" ] && [ "$INSTALL_HL2" != "true" ]; then
		mount=${mount}'        "hl2"    "'"${TF2_PATH}/hl2"'"\n'
	fi
fi
if [ "$INSTALL_HLDM" = "true" ]; then
	echo "installing & mounting hldm"
	./steamcmd.sh +login anonymous +force_install_dir "$HLDM_PATH" +app_update 255470 validate +quit
	mount=${mount}'        "hl1"    "'"${HLDM_PATH}/hl1"'"\n'
	mount=${mount}'        "hldm"    "'"${HLDM_PATH}/hldm"'"\n'
	if [ "$INSTALL_CSS" != "true" ] && [ "$INSTALL_HL2" != "true" ] && [ "$INSTALL_TF2" != "true" ]; then
		mount=${mount}'        "hl2"    "'"${HLDM_PATH}/hl2"'"\n'
	fi
fi
mount=${mount}$'}'


if [ ! -e "${SERVER_PATH}/garrysmod/cfg" ]; then
	mkdir -p "${SERVER_PATH}/garrysmod/cfg"
fi
if [ -e "${SERVER_PATH}/garrysmod/cfg/mount.cfg" ]; then
	rm "${SERVER_PATH}/garrysmod/cfg/mount.cfg"
fi
touch "${SERVER_PATH}/garrysmod/cfg/mount.cfg"
echo "$mount" > "${SERVER_PATH}/garrysmod/cfg/mount.cfg"

