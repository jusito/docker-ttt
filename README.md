# docker-ttt
Garry's mod, gamemode TTT as docker image: https://hub.docker.com/r/jusito/

## Getting Started
1. Create 2 workshop collections. One containing Maps and a subcollection. Subcollection containing all non-map elements.
2. Do you want forced auto download? If no go 3., if yes use `-e WORKSHOP_COLLECTION_ID=*SubCollectionID*`.
3. Let Gmod server know which collection should be used. `[...]jusito/docker-ttt:beta +host_workshop_collection *MainCollectionID* [...]`
4. Do you want CSS or other game content installed and mounted(CSS recommended)? If no go 5., if yes `-e INSTALL_CSS=true` or see environment variables.
5. Choose your ports. Default is 27015. `docker run [...] -p 27015:27015/tcp jusito/docker-ttt:beta -port 27015 [...]`

### run example
```
docker run -dit -p 27015:27015/tcp -p 27015:27015/udp -e WORKSHOP_COLLECTION_ID=123456 -e INSTALL_CSS=true "jusito/docker-ttt:beta" -port 27015 +host_workshop_collection 123456 +map ttt_rooftops_2016_v1 -maxplayers 16 
```
 * _-it_ needed for seeing all output if attached
 * _27015/tcp_(optional) - rcon port, you will need this too: -usercon +rcon_password "yourPW"
 * _27015/udp_ - udp port for game traffic
 * _-port 27015_ - only needed if you want to use non-default port, docker -p 27016:27015 will _not_ work.
 * _-e WORKSHOP_COLLECTION_ID_(optional) - add every element to forced
 * _-e INSTALL_CSS_(optional) - download CSS and mount it
 * _+host_workshop_collection_ - Garry's Mod will load this collection
 * _+map_(optional) - default map to start
 * _-maxplayers_(optional) - max count of players
 
### whats missing, why tag beta:
1. cron service needs to be started otherwise the server will get only updates on restart
2. force cleanup of downloaded elements => removed workshop elements are otherwise used
3. I failed to create a proper volume, mount /home/steam/serverfiles.

## environment variables
| Variable | Default | Description | Example |
|----------|---------|-------------|---------|
|WORKSHOP_COLLECTION_ID|""(empty)|Every element on this list is set to forced download. The users don't need to subscribe to your collection. Don't add maps here, they are already forced by default.|1358835428|
|||||
|SERVER_NAME|""(empty)|overwrite server.cfg value|"[TTT] dockerized"|
|SERVER_PASSWORD|""(empty)|overwrite server.cfg value|"SecurePW"|
|SERVER_VOICE_ENABLE|1|overwrite server.cfg value|0 (disabling ingame voice)|
|||||
|INSTALL_CSS|false|Install & Mount CSS. Most of the time you will set this to true.|true|
|INSTALL_HL2|false|Install & Mount HL2.|true|
|INSTALL_HLDM|false|Install & Mount HLDM.|true|
|INSTALL_TF2|false|Install & Mount TF2.|true|

## server config
* [TTT config variables](http://ttt.badking.net/config-and-commands/convars)
* [Server.cfg variables](https://wiki.garrysmod.de/server.cfg)


## Additional
 * Attach to console after start, `docker exec -it _CONTAINER_ /home/steam/gmodserver console`
 * Copy your server.cfg in, `docker cp "your server.cfg path" CONTAINER:/home/steam/serverfiles/garrysmod/cfg/server.cfg`


