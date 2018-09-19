#!/bin/bash

set -e

#create default server.config
#TODO don't miss to change to master!
if [ ! -e "{$SERVER_PATH}/garrysmod/cfg/server.cfg" ]; then
	mkdir -p "{$SERVER_PATH}/garrysmod/cfg"
	wget -O "{$SERVER_PATH}/garrysmod/cfg/server.cfg" "https://raw.githubusercontent.com/jusito/docker-ttt/develop/server.cfg"
fi

#this is a simple option for myself, but you can use it too
if [ "$USE_MY_REPLACER_CONFIG" = "true" ]; then
	mkdir -p "{$SERVER_PATH}/garrysmod/data/jusito_ttt_entity_replace"
	wget -O "{$SERVER_PATH}/garrysmod/data/jusito_ttt_entity_replace/config.txt" "https://raw.githubusercontent.com/jusito/ttt_entity_replace/master/config.txt.example_fas2"
fi

