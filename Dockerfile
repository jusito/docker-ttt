FROM ubuntu:18.04

EXPOSE 27015/udp 27015/tcp

ENV STEAM_PATH="/home/steam" \
	SERVER_PATH="/home/steam/server" \
	GROUP_ID=10000 \
	USER_ID=10000 \
	DOCKER_USER=steam
	
ENTRYPOINT ["./home/entrypoint.sh"]
	
COPY ["entrypoint.sh", "/home/"]

# removed dep. lib32gcc1 libtcmalloc-minimal4:i386 gdb
RUN dpkg --add-architecture i386 && \
	apt-get update -y && \
	apt-get install -y wget tar gzip ca-certificates lib32gcc1 lib32stdc++6 lib32ncurses5 lib32z1 locale-gen && \
	\
	groupadd -g $GROUP_ID $DOCKER_USER && \
	useradd -d /home/steam/ -g $GROUP_ID -u $USER_ID -m $DOCKER_USER && \
	chown "$DOCKER_USER:$DOCKER_USER" /home/entrypoint.sh && \
	mkdir -p "$SERVER_PATH" && \
	chown -R "$DOCKER_USER:$DOCKER_USER" "$STEAM_PATH" && \
	chmod a=rx /home/entrypoint.sh && \
	ulimit -n 2048 && \
	\
	locale-gen en_US.UTF-8	

USER "$USER_ID:$GROUP_ID"

VOLUME "$SERVER_PATH"