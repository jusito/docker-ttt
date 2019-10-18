# GMOD TTT
GMOD TTT server image, https://hub.docker.com/r/jusito/

## Important
If you use the old image, you should check the environment variables. For example arguments after image name aren't used, use instead `-e SERVER_ADDITIONAL_PARAMETERS=...`.
This readme may not be perfect, if you struggle at some point or you see incorrect informations create an issue at git please.

## Getting Started
### Prepare your server content
1. Create public workshop collection without maps, dummy ID:=123456. Use `-e WORKSHOP_COLLECTION_ID 123456`.
2. Create public workshop collection with maps and add this one to "123456".
3. Do you want every user to load the content automatically? Yes you are done, no `-e WORKSHOP_AUTOLOAD=false`. Remember that "false" mean, that every user has to manually subscribe to your collection. If you don't separate maps / others, every connecting user would load all maps on first connecting. This would be a pain for some.
4. Do your content needs CSS, HL2, HLDM, TF2? Use `-e INSTALL_CSS=true` and/or `-e INSTALL_HL2=true` and so on. Most content will need at least CSS.

### Server config
1. Pick your ports `-e SERVER_PORT=27015 -p 27015:27015/udp` both are always needed. For RCON `[...] -e SERVER_RCON_PASSWORD="verySecure" -p 27015:27015/tcp`.
2. Set environment variables like servername `-e SERVER_NAME="My Server"`, password `-e SERVER_PASSWORD="securepw"` and timezone for cron `-e TZ="Europe/Berlin"`, default short downtime at Sunday 10 o'clock.
3. Choose startmap (can be from workshop collection, even linked) `-e SERVER_DEFAULT_MAP=ttt_rooftops_2016_v1` and max players `-e SERVER_MAX_PLAYERS=20`
4. Get a volume name `-v TTTDev:/home/steam/serverfiles`

### run example without rcon
If you need rcon only sometimes, use ulx with this config.

```
docker run -d \
 -p 27015:27015/udp \
 -e SERVER_PORT=27015 \
 -e INSTALL_CSS=true \
 -e WORKSHOP_COLLECTION_ID=123456 \
 -e SERVER_NAME="My Server" \
 -e SERVER_PASSWORD="securepw" \
 -e SERVER_DEFAULT_MAP="ttt_lttp_kakariko_a4" \
 -v TTTDev:/home/steam/serverfiles \
 --name "MyTTTServer" \
 jusito/docker-ttt:gmod_ttt_debian
```

### run example with rcon
```
docker run -d \
 -p 27015:27015/udp \
 -e SERVER_PORT=27015 \
 -e INSTALL_CSS=true \
 -e WORKSHOP_COLLECTION_ID=123456 \
 -e SERVER_NAME="My Server" \
 -e SERVER_PASSWORD="securepw" \
 -e SERVER_DEFAULT_MAP="ttt_lttp_kakariko_a4" \
 -v TTTDev:/home/steam/serverfiles \
 -p 27015:27015/tcp \
 -e SERVER_RCON_PASSWORD="securePW" \
 --name "MyTTTServer" \
 jusito/docker-ttt:gmod_ttt_debian
```

## Tags
* lgsm\_debian - Linux Game Server Manager in Debian
* gmod\_debian - Garrys Mod with Debian and LGSM
* gmod\_ttt\_debian - Gamemode TTT with LGSM/Debian

## Environment Variables
Because you will most likely use many environmental variables, I recommend a env list. Instead of `-e VARNAME="VALUE 1"` write one additional text file:

TTT.env:

```
VARNAME=Value 1
SERVER_NAME=My Hood
SERVER_PASSWORD=Secure_PW
```
### LGSM Properties
#### Free to change
|Name|Default|Description|
|----|-------|-----------|
|CRON\_MONITOR|"\*/5 \* \* \* \*"|Every 5 minutes LGSM checks if the server is running and responding, rebooting if needed.|
|CRON\_UPDATE|"\*/30 \* \* \* \*"|Every 30 minutes LGSM checks if game server needs an update which will be executed.|
|CRON\_FORCE\_UPDATE|"0 10 \* \* 0"|At Sunday 10:00 force update and restart|
|CRON\_LOG_ROTATE|"0 9 \* \* 0"|Rotate log at Stunday 9:00|
|TZ|Europe/Berlin|[Set timezone for CRON / log](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones)|

#### Used for subimage
|Name|Default|Description|
|----|-------|-----------|
|SERVER_EXECUTABLE|""|Name of the lgsm script after installation|
|SERVER_GAME|""|LGSM name of installation|

#### LGSM Internal
<details><summary>LGSM Internal Properties (click me)</summary>
<p>

|Name|Default|Description|
|----|-------|-----------|
|STEAM_PATH|/home/steam|primary workdir, homedir of user|
|SERVER_PATH|/home/steam/serverfiles|Path to serverfiles after installation|
|STEAM_CMD|/home/steam/steamcmd|Path to steamcmd files|
|GROUP_ID|10000|Group ID of the user|
|USER_ID|10000|User ID of the user|
|DOCKER_USER|steam|Name of the user|
|SUPERCRONIC_URL|https://github.com/aptible/supercronic/releases/download/v0.1.9/supercronic-linux-amd64|CRON version|
|SUPERCRONIC|supercronic-linux-amd64|CRON name after download|
|SUPERCRONIC_SHA1SUM|5ddf8ea26b56d4a7ff6faecdd8966610d5cb9d85|CRC for CRON download|
|DEBIAN_FRONTEND|noninteractive|Don't ask questions during installation|
|LANG|C.UTF-8|Language set|
|TERM|xterm||
|DEBUGGING|false||

</p>
</details>

### GMOD Properties
#### GMOD Content
|Name|Default|Description|
|----|-------|-----------|
|INSTALL\_CSS|false|Should I install and mount CSS?|
|INSTALL\_HL2|false|Should I install and mount HL2?|
|INSTALL\_HLDM|false|Should I install and mount HLDM?|
|INSTALL\_TF2|false|Should I install and mount TF2?|
|WORKSHOP\_COLLECTION_ID|""|Workshop Collection ID for the server. If you use AUTOLOAD you should add maps on a linked collection|
|WORKSHOP\_API_KEY|""|Maybe needed for private content.|
|WORKSHOP\_AUTOLOAD|true|Every item which is on the given collection, will be downloaded by every client. Elements on linked collections not - so use maps in a linked collection.|

#### GMOD Server
|Name|Default|Description|
|----|-------|-----------|
|SERVER\_NAME|LinuxGSM||
|SERVER\_PASSWORD|""||
|SERVER\_RCON\_PASSWORD|""||
|SERVER\_VOICE\_ENABLE|1||
|SERVER\_IP|0.0.0.0||
|SERVER\_PORT|27015||
|SERVER\_CLIENTPORT|27005||
|SERVER\_SOURCETVPORT|27020||
|SERVER\_DEFAULT\_MAP|gm\_construct||
|SERVER\_MAX\_PLAYERS|16||
|SERVER\_TICKRATE|66||
|SERVER\_GAMEMODE|sandbox||
|SERVER\_LOGIN\_TOKEN|""||
|SERVER\_ADDITIONAL\_PARAMETERS|-disableluarefresh||
	
#### GMOD LGSM specific
These variables are untested, but if they dont work report it please too. [Documentation](https://docs.linuxgsm.com/alerts)

|Name|Default|Description|
|----|-------|-----------|
|LGSM\_DISPLAYIP|""||
|LGSM\_POSTALERT|off||
|LGSM\_POSTDAYS|7||
|LGSM\_POSTTARGET|https://hastebin.com||
|LGSM\_DISCORDALERT|off||
|LGSM\_DISCORDWEBHOOK|webhook||
|LGSM\_EMAILALERT|off||
|LGSM\_EMAIL|email@example.com||
|LGSM\_EMAILFROM|""||
|LGSM\_IFTTTALERT|off||
|LGSM\_IFTTTTOKEN|accesstoken||
|LGSM\_IFTTTEVENT|linuxgsm\_alert||
|LGSM\_MAILGUNALERT|off||
|LGSM\_MAILGUNTOKEN|accesstoken||
|LGSM\_MAILGUNDOMAIN|example.com||
|LGSM\_MAILGUNEMAILFROM|alert@example.com||
|LGSM\_MAILGUNEMAIL|email@myemail.com||
|LGSM\_PUSHBULLETALERT|off||
|LGSM\_PUSHBULLETTOKEN|accesstoken||
|LGSM\_CHANNELTAG|""||
|LGSM\_PUSHOVERALERT|off||
|LGSM\_PUSHOVERTOKEN|accesstoken||
|LGSM\_TELEGRAMALERT|off||
|LGSM\_TELEGRAMTOKEN|accesstoken||
|LGSM\_TELEGRAMCHATID|""||
|LGSM\_CURLCUSTOMSTRING|""||
|LGSM\_UPDATEONSTART|off||
|LGSM\_MAXBACKUPS|4||
|LGSM\_MAXBACKUPDAYS|30||
|LGSM\_STOPONBACKUP|on||
|LGSM\_CONSOLELOGGING|on||
|LGSM\_LOGDAYS|7||
|LGSM\_QUERYDELAY|5||
|LGSM\_BRANCH|""||
|LGSM\_STEAMMASTER|true"||

#### GMOD Internal
<details><summary>GMOD Internal Properties (click me)</summary>
<p>

|Name|Default|Description|
|----|-------|-----------|
|CSS_PATH|/home/steam/addons/css||
|HL2_PATH|/home/steam/addons/hl2||
|HLDM_PATH|/home/steam/addons/hldm||
|TF2_PATH|/home/steam/addons/tf2||
|SERVER_EXECUTABLE|gmodserver||
|SERVER_GAME|gmodserver||

</p>
</details>

### TTT Properties
#### TTT Internal Properties
|Name|Default|Description|
|----|-------|-----------|
|SERVER_GAMEMODE|"terrortown"||

## LGSM Usage
The container provides links to [LGSM commands](https://docs.linuxgsm.com/commands):
* docker exec -it CONTAINER details // print various informations like passwords, name, players, status aso.
* docker exec -it CONTAINER backup
* docker exec -it CONTAINER console // let you view the current console, docker logs will not work
* docker exec -it CONTAINER debug
* docker exec -it CONTAINER force-update
* docker exec -it CONTAINER install
* docker exec -it CONTAINER monitor
* docker exec -it CONTAINER postdetails
* docker exec -it CONTAINER restart
* docker exec -it CONTAINER start
* docker exec -it CONTAINER stop
* docker exec -it CONTAINER test-alert
* docker exec -it CONTAINER update
* docker exec -it CONTAINER update-lgsm
* docker exec -it CONTAINER validate

## File Locations
### Volumes
/home/steam/serverfiles

### Other
server.cfg: /home/steam/serverfiles/garrysmod/cfg/gmodserver.cfg
hostname, password, rcon password, voice enabled are managed / will be overwritten

## server config
http://ttt.badking.net/config-and-commands/convars
https://wiki.garrysmod.de/server.cfg

Path in container is:
docker cp "your server.cfg path" CONTAINER:/home/steam/serverfiles/garrysmod/cfg/gmodserver.cfg


## Additional
- Debian Buster, one dependency is missing: https://packages.debian.org/search?keywords=lib32tinfo5
- Alpine, steamcmd doesn't like musl

### TODO
#### image improvements
* volume for steam workshop
* volume for other games
* volume for gmod config (data folder)
* AppArmor Profile

#### image config, description needed
* scrds doesn't like different internal / external ports (thats why no ports are exposed)
* health check -> details

### For local usage
navigate to directory with readme.md
bash test/testBuild.sh (sh doesn't like pipefail, escape if you want to use sh)


## FTP Server
* If your Volume is TTTDev
* If you didn't change UserID / GroupID
* If you want to connect to ftp://...:123 (ports 122/123 are free on your network)

### For FileZilla

```
docker run -d \
 -e MY_NAME="docker" -e MY_PASSWORD="MySecurePW" \
 -e MY_USER_ID="10000" -e MY_GROUP_ID="10000" \
 -p 122:20 -p 123:21 -p 10090-10100:10090-10100 \
 -v TTTDev:/home/docker/ \
 jusito/vsftpd-alpine:simple
```

### For Windows Network Mount
* IP of the Host (not container) 1.2.3.4
* Mount: ftp://1.2.3.4:123

```
docker run -d \
 -e MY_NAME="docker" -e MY_PASSWORD="MySecurePW" \
 -e MY_USER_ID="10000" -e MY_GROUP_ID="10000" \
 -p 122:20 -p 123:21 -p 10090-10100:10090-10100 \
 -v TTTDev:/home/docker/ \
 -e pasv_address="1.2.3.4" \
 jusito/vsftpd-alpine:simple
```