FROM debian:stretch-slim

# Const \\ Overwrite Env \\ Configs possible \\ Configs needed 
# C.UTF-8 -> en_US.UTF-8
ENV STEAM_PATH="/home/steam" \
	SERVER_PATH="/home/steam/serverfiles" \
	STEAM_CMD="/home/steam/steamcmd" \
	GROUP_ID=10000 \
	USER_ID=10000 \
	DOCKER_USER=steam \
	SUPERCRONIC_URL=https://github.com/aptible/supercronic/releases/download/v0.1.9/supercronic-linux-amd64 \
	SUPERCRONIC=supercronic-linux-amd64 \
	SUPERCRONIC_SHA1SUM=5ddf8ea26b56d4a7ff6faecdd8966610d5cb9d85 \
	\
	\
	DEBIAN_FRONTEND=noninteractive \
	LANG=C.UTF-8 \
	TERM=xterm \
	\
	\
	DEBUGGING=false \
	CRON_MONITOR="*/5 * * * *" \
	CRON_UPDATE="*/30 * * * *" \
	CRON_FORCE_UPDATE="0 10 * * 0" \
	CRON_LOG_ROTATE="0 0 * * 0" \
	\
	\
	SERVER_EXECUTABLE="" \
	SERVER_GAME="" \
	TZ="Europe/Berlin"
#https://en.wikipedia.org/wiki/List_of_tz_database_time_zones

ENTRYPOINT ["./home/entrypoint.sh"]

#WORKDIR "$STEAM_PATH"
	
COPY ["entrypoint.sh", "initCron.sh", "createAlias.sh", "/home/"]

# procps needed for ps command
# iproute2 needed because of "-slim"
RUN dpkg --add-architecture i386 && \
	apt-get update -y && \
	apt-get install -y mailutils postfix curl wget file bzip2 gzip unzip bsdmainutils python util-linux ca-certificates \
		binutils bc jq tmux lib32gcc1 libstdc++6 libstdc++6:i386 lib32tinfo5 \
		procps iproute2 && \
	\
	groupadd -g $GROUP_ID $DOCKER_USER && \
	useradd -d "$STEAM_PATH" -g $GROUP_ID -u $USER_ID -m $DOCKER_USER && \
	chown "$DOCKER_USER:$DOCKER_USER" /home/entrypoint.sh && \
	chown "$DOCKER_USER:$DOCKER_USER" /home/initCron.sh && \
	mkdir -p "$SERVER_PATH" && \
	chown -R "$DOCKER_USER:$DOCKER_USER" "$STEAM_PATH" && \
	chmod a=rx /home/entrypoint.sh && \
	chmod a=rx /home/initCron.sh && \
	chmod a=rx /home/createAlias.sh && \
	\
	ulimit -n 2048 && \
	\
	wget -O "$STEAM_PATH/linuxgsm.sh" "https://linuxgsm.sh" && \
	chown "$DOCKER_USER:$DOCKER_USER" "$STEAM_PATH/linuxgsm.sh" && \
	chmod +x "$STEAM_PATH/linuxgsm.sh" && \
	\
	\
	wget -O "${SUPERCRONIC}" "$SUPERCRONIC_URL" && \
	echo "${SUPERCRONIC_SHA1SUM}  ${SUPERCRONIC}" | sha1sum -c - && \
	chmod +x "$SUPERCRONIC"  && \
	mv "$SUPERCRONIC" "/usr/local/bin/${SUPERCRONIC}" && \
	ln -s "/usr/local/bin/${SUPERCRONIC}" /usr/local/bin/supercronic

