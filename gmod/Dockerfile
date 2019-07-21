FROM jusito/docker-ttt:lgsm_debian

EXPOSE 27015/udp 27015/tcp

# Const \\ Overwrite Env \\ Configs optional \\ Configs needed 
ENV CSS_PATH="/home/steam/addons/css" \
	HL2_PATH="/home/steam/addons/hl2" \
	HLDM_PATH="/home/steam/addons/hldm" \
	TF2_PATH="/home/steam/addons/tf2" \
	\
	\
	SERVER_EXECUTABLE="gmodserver" \
	SERVER_GAME="gmodserver" \
	\
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
	USE_MY_REPLACER_CONFIG=false \
	\
	\
	SERVER_GAMEMODE=""

COPY ["prepareServer.sh", "initConfig.sh", "forceWorkshopDownload.sh", "installAndMountAddons.sh", "/home/"]

RUN chown "$DOCKER_USER:$DOCKER_USER" /home/prepareServer.sh && \
	chown "$DOCKER_USER:$DOCKER_USER" /home/initConfig.sh && \
	chown "$DOCKER_USER:$DOCKER_USER" /home/forceWorkshopDownload.sh && \
	chown "$DOCKER_USER:$DOCKER_USER" /home/installAndMountAddons.sh && \
	chmod a=rx /home/prepareServer.sh && \
	chmod a=rx /home/initConfig.sh && \
	chmod a=rx /home/forceWorkshopDownload.sh && \
	chmod a=rx /home/installAndMountAddons.sh
