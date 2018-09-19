# docker-ttt
GMOD TTT server image, https://hub.docker.com/r/jusito/

## TODO
- use readme template
- create script which adds all workshop donwloads to lua (arg host_workshop_collection)
  - \lua\autorun\server\workshop.lua, resource.AddWorkshop( "943738100" )
- force cleanup of downloaded elements => removed workshop elements are otherwise used

## run example
```
docker run -d -p 27015:27015/tcp -p 27015:27015/udp -e WORKSHOP_COLLECTION_ID=123456 -e INSTALL_CSS=true "jusito/docker-ttt" +host_workshop_collection 123456 +map ttt_rooftops_2016_v1 -maxplayers 16 -hostname "New Server"
```
-d exit if entrypoint exits
tcp port for rcon
udp port for game traffic

## environment variables
If set every workshop item at the collection is added as forced, that means its automatically downloaded on connecting. Don't add collections with maps here just like weapons aso.
WORKSHOP_COLLECTION_ID=

If set to "true" the game is installed and mounted, most of the time you want to add the css content.
INSTALL_CSS=false
INSTALL_HL2=false
INSTALL_HLDM=false
INSTALL_TF2=false

## server config
http://ttt.badking.net/config-and-commands/convars

Path in container is:
docker cp "your server.cfg path" CONTAINER:/home/steam/server/garrysmod/cfg/server.cfg

