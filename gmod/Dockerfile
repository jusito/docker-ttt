FROM jusito/docker-ttt:lgsm_debian

# Const \\ Overwrite Env \\ Configs optional
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
	WORKSHOP_COLLECTION_ID="" \
	WORKSHOP_API_KEY="" \
	WORKSHOP_AUTOLOAD="true" \
	SERVER_NAME="LinuxGSM" \
	SERVER_PASSWORD="" \
	SERVER_RCON_PASSWORD="" \
	SERVER_VOICE_ENABLE="1" \
	SERVER_IP="0.0.0.0" \
	SERVER_PORT="27015" \
	SERVER_CLIENTPORT="27005" \
	SERVER_SOURCETVPORT="27020" \
	SERVER_DEFAULT_MAP="gm_construct" \
	SERVER_MAX_PLAYERS="16" \
	SERVER_TICKRATE="66" \
	SERVER_GAMEMODE="sandbox" \
	SERVER_LOGIN_TOKEN="" \
	SERVER_ADDITIONAL_PARAMETERS="-disableluarefresh" \
	LGSM_DISPLAYIP="" \
	LGSM_POSTALERT="off" \
	LGSM_POSTDAYS="7" \
	LGSM_POSTTARGET="https://hastebin.com" \
	LGSM_DISCORDALERT="off" \
	LGSM_DISCORDWEBHOOK="webhook" \
	LGSM_EMAILALERT="off" \
	LGSM_EMAIL="email@example.com" \
	LGSM_EMAILFROM="" \
	LGSM_IFTTTALERT="off" \
	LGSM_IFTTTTOKEN="accesstoken" \
	LGSM_IFTTTEVENT="linuxgsm_alert" \
	LGSM_MAILGUNALERT="off" \
	LGSM_MAILGUNTOKEN="accesstoken" \
	LGSM_MAILGUNDOMAIN="example.com" \
	LGSM_MAILGUNEMAILFROM="alert@example.com" \
	LGSM_MAILGUNEMAIL="email@myemail.com" \
	LGSM_PUSHBULLETALERT="off" \
	LGSM_PUSHBULLETTOKEN="accesstoken" \
	LGSM_CHANNELTAG="" \
	LGSM_PUSHOVERALERT="off" \
	LGSM_PUSHOVERTOKEN="accesstoken" \
	LGSM_TELEGRAMALERT="off" \
	LGSM_TELEGRAMTOKEN="accesstoken" \
	LGSM_TELEGRAMCHATID="" \
	LGSM_CURLCUSTOMSTRING="" \
	LGSM_UPDATEONSTART="off" \
	LGSM_MAXBACKUPS="4" \
	LGSM_MAXBACKUPDAYS="30" \
	LGSM_STOPONBACKUP="on" \
	LGSM_CONSOLELOGGING="on" \
	LGSM_LOGDAYS="7" \
	LGSM_QUERYDELAY="5" \
	LGSM_BRANCH="" \
	LGSM_STEAMMASTER="true" \
	\
	INSTALL_CSS=false \
	INSTALL_HL2=false \
	INSTALL_HLDM=false \
	INSTALL_TF2=false \
	\
	USE_MY_REPLACER_CONFIG=false
	

COPY ["prepareServer.sh", "initConfig.sh", "forceWorkshopDownload.sh", "installAndMountAddons.sh", "common.cfg", "/home/"]

RUN chown "$DOCKER_USER:$DOCKER_USER" /home/prepareServer.sh && \
	chown "$DOCKER_USER:$DOCKER_USER" /home/initConfig.sh && \
	chown "$DOCKER_USER:$DOCKER_USER" /home/forceWorkshopDownload.sh && \
	chown "$DOCKER_USER:$DOCKER_USER" /home/installAndMountAddons.sh && \
	chmod a=rx /home/prepareServer.sh && \
	chmod a=rx /home/initConfig.sh && \
	chmod a=rx /home/forceWorkshopDownload.sh && \
	chmod a=rx /home/installAndMountAddons.sh
