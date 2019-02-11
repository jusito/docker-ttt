FROM jusito/lgsm:latest

ENV LGSM_GAMESERVER="gmodserver" \
	LGSM_EXECUTABLE="gmodserver" \
	LGSM_STOP_SCRIPT="/home/stop.sh" \
	GAMECONFIG_SCRIPT="/home/config.sh" \
	\
	WORKSHOP_COLLECTION_ID="" \
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
	USE_MY_REPLACER_CONFIG=false

COPY ["config.sh", "stop.sh", "forceWorkshopDownload.sh", "installAndMountAddons.sh", "/home/"]

RUN chown "$DOCKER_USER:$DOCKER_USER" "/home/config.sh" && \
	chown "$DOCKER_USER:$DOCKER_USER" "/home/stop.sh" && \
	chown "$DOCKER_USER:$DOCKER_USER" "/home/forceWorkshopDownload.sh" && \
	chown "$DOCKER_USER:$DOCKER_USER" "/home/installAndMountAddons.sh" && \
	\
	chmod a=rx /home/config.sh && \
	chmod a=rx /home/stop.sh && \
	chmod a=rx /home/forceWorkshopDownload.sh && \
	chmod a=rx /home/installAndMountAddons.sh
	
USER "$USER_ID:$GROUP_ID"

VOLUME "$SERVER_PATH"