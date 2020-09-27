ARG SUFFIX=""

FROM jusito/docker-ttt:gmod_debian${SUFFIX}
	
ENV SERVER_GAMEMODE="terrortown"

COPY "server.cfg.default" "/home/server.cfg.default"

USER "$USER_ID:$GROUP_ID"

VOLUME "$SERVER_PATH"