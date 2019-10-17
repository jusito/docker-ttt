FROM jusito/docker-ttt:gmod_debian
	
ENV SERVER_GAMEMODE="terrortown"

COPY "TTT/server.cfg.default" "/home/server.cfg.default"

USER "$USER_ID:$GROUP_ID"

VOLUME "$SERVER_PATH"