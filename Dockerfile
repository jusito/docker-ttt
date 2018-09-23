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
	apt-get install -y wget tar gzip ca-certificates lib32gcc1 lib32stdc++6 lib32ncurses5 lib32z1 locales lib32tinfo5 libtcmalloc-minimal4:i386 gdb && \
	\
	chmod a=rx /home/entrypoint.sh && \
	ulimit -n 2048 && \
	\
	locale-gen en_US.UTF-8	

USER "root:root"

VOLUME "$SERVER_PATH"