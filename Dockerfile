FROM ubuntu:16.04

EXPOSE 27015/udp 27015/tcp

ENV STEAM_PATH="/home/steam" \
	SERVER_PATH="/home/steam/serverfiles" \
	STEAM_CMD="/home/steam/steamcmd" \
	GROUP_ID=10000 \
	USER_ID=10000 \
	DOCKER_USER=steam \
	\
	WORKSHOP_COLLECTION_ID= \
	SERVER_NAME="" \
	SERVER_PASSWORD="" \
	SERVER_VOICE_ENABLE="1" \
	\
	INSTALL_CSS=false \
	INSTALL_HL2=false \
	INSTALL_HLDM=false \
	INSTALL_TF2=false \
	\
	CSS_PATH="/home/steam/addons/css" \
	HL2_PATH="/home/steam/addons/hl2" \
	HLDM_PATH="/home/steam/addons/hldm" \
	TF2_PATH="/home/steam/addons/tf2" \
	\
	USE_MY_REPLACER_CONFIG=false \
	DEBIAN_FRONTEND=noninteractive

ENTRYPOINT ["./home/entrypoint.sh"]
	
COPY ["entrypoint.sh", "experimental.sh", "forceWorkshopDownload.sh", "installAndMountAddons.sh", "/home/"]

# removed dep. lib32gcc1 libtcmalloc-minimal4:i386 gdb
RUN dpkg --add-architecture i386 && \
	apt-get update -y && \
	apt-get install -y mailutils postfix curl wget file bzip2 gzip unzip bsdmainutils python util-linux ca-certificates \
		binutils bc jq tmux lib32gcc1 libstdc++6 libstdc++6:i386 lib32tinfo5 \
		locales sudo && \
	\
	groupadd -g $GROUP_ID $DOCKER_USER && \
	useradd -d "$STEAM_PATH" -g $GROUP_ID -u $USER_ID -m $DOCKER_USER && \
	chown "$DOCKER_USER:$DOCKER_USER" /home/entrypoint.sh && \
	sudo -u "$DOCKER_USER" mkdir -p "$SERVER_PATH" && \
	chown -R "$DOCKER_USER:$DOCKER_USER" "$STEAM_PATH" && \
	chmod a=rx /home/entrypoint.sh && \
	chmod a=rx /home/experimental.sh && \
	chmod a=rx /home/forceWorkshopDownload.sh && \
	chmod a=rx /home/installAndMountAddons.sh && \
	\
	ulimit -n 2048 && \
	locale-gen en_US.UTF-8 && \
	\
	wget -O "$STEAM_PATH/linuxgsm.sh" "https://linuxgsm.sh" && \
	chown "$DOCKER_USER:$DOCKER_USER" "$STEAM_PATH/linuxgsm.sh" && \
	chmod +x "$STEAM_PATH/linuxgsm.sh"
	
USER "$USER_ID:$GROUP_ID"

VOLUME "$SERVER_PATH"
