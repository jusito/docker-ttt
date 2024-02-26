FROM debian:buster-slim as lgsm

# Const \\ Overwrite Env \\ Configs possible \\ Configs needed 
# C.UTF-8 -> en_US.UTF-8
ENV STEAM_PATH="/home/steam" \
	SERVER_PATH="/home/steam/serverfiles" \
	STEAM_CMD="/home/steam/.steam/steamcmd" \
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

COPY ["lgsm/entrypoint.sh", "lgsm/initCron.sh", "lgsm/createAlias.sh", "/home/"]

# procps needed for ps command
# iproute2 needed because of "-slim"
RUN dpkg --add-architecture i386 && \
	apt-get update -y && \
	apt-get install -y bc binutils bsdmainutils bzip2 ca-certificates cpio curl file gzip hostname jq lib32gcc1 lib32stdc++6 netcat python3 tar tmux unzip util-linux wget xz-utils lib32gcc1 lib32stdc++6 libsdl2-2.0-0:i386 distro-info \
		libtinfo5:i386 \
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

FROM lgsm as gmod

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
	WORKSHOP_API_KEY="01BE63665A58CE882C8030630167E1DB" \
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
	SERVER_LOGIN_TOKEN="58B1618059E8483F37890D1966C8755B" \
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
	LGSM_UPDATE=true \
	\
	USE_MY_REPLACER_CONFIG=false
	

COPY ["gmod/prepareServer.sh", "gmod/initConfig.sh", "gmod/forceWorkshopDownload.sh", "gmod/installAndMountAddons.sh", "gmod/common.cfg", "/home/"]

RUN chown "$DOCKER_USER:$DOCKER_USER" /home/prepareServer.sh && \
	chown "$DOCKER_USER:$DOCKER_USER" /home/initConfig.sh && \
	chown "$DOCKER_USER:$DOCKER_USER" /home/forceWorkshopDownload.sh && \
	chown "$DOCKER_USER:$DOCKER_USER" /home/installAndMountAddons.sh && \
	chmod a=rx /home/prepareServer.sh && \
	chmod a=rx /home/initConfig.sh && \
	chmod a=rx /home/forceWorkshopDownload.sh && \
	chmod a=rx /home/installAndMountAddons.sh && \
	\
	/home/createAlias.sh "backup" '/home/steam/gmodserver backup' && \
	/home/createAlias.sh "console" '/home/steam/gmodserver console' && \
	/home/createAlias.sh "debug" '/home/steam/gmodserver debug' && \
	/home/createAlias.sh "details" '/home/steam/gmodserver details' && \
	/home/createAlias.sh "force-update" '/home/steam/gmodserver force-update' && \
	/home/createAlias.sh "install" '/home/steam/gmodserver install' && \
	/home/createAlias.sh "monitor" '/home/steam/gmodserver monitor' && \
	/home/createAlias.sh "postdetails" '/home/steam/gmodserver postdetails' && \
	/home/createAlias.sh "restart" '/home/steam/gmodserver restart' && \
	/home/createAlias.sh "start" '/home/steam/gmodserver start' && \
	/home/createAlias.sh "stop" '/home/steam/gmodserver stop' && \
	/home/createAlias.sh "test-alert" '/home/steam/gmodserver test-alert' && \
	/home/createAlias.sh "update" '/home/steam/gmodserver update' && \
	/home/createAlias.sh "update-lgsm" '/home/steam/gmodserver update-lgsm' && \
	/home/createAlias.sh "validate" '/home/steam/gmodserver validate'

FROM gmod as TTT

ENV SERVER_GAMEMODE="terrortown"

COPY "TTT/server.cfg.default" "/home/server.cfg.default"

USER "$USER_ID:$GROUP_ID"

VOLUME "$SERVER_PATH"
