FROM ubuntu:16.04

EXPOSE 27015/udp 27015/tcp

ENV STEAM_PATH="/home/steam" \
	SERVER_PATH="/home/steam/server" \
	GROUP_ID=10000 \
	USER_ID=10000 \
	DOCKER_USER=steam \
	\
	DEBIAN_FRONTEND="noninteractive"
	
ENTRYPOINT ["./home/entrypoint.sh"]
CMD ["-game", "garrysmod", "+gamemode", "sandbox", "+map", "gm_flatgrass"]
	
COPY ["entrypoint.sh", "/home/"]

# removed dep. lib32gcc1 libtcmalloc-minimal4:i386 gdb libreadline5 
RUN dpkg --add-architecture i386 && \
	apt-get update -y && \
	apt-get install -y mailutils postfix curl wget file bzip2 gzip unzip bsdmainutils python util-linux ca-certificates binutils bc jq tmux lib32gcc1 libstdc++6 libstdc++6:i386 lib32tinfo5 && \
	locales \
	\
	chmod a=rx /home/entrypoint.sh && \
	\
	locale-gen en_US.UTF-8 && \
	wget -O linuxgsm.sh https://linuxgsm.sh && chmod +x linuxgsm.sh && bash linuxgsm.sh gmodserver

USER "root:root"

VOLUME "$SERVER_PATH"