#!/bin/bash

if [ "${DEBUGGING}" = "true" ]; then
	set -o xtrace
else
	DEBUGGING="false"
fi

set -o errexit
set -o nounset
set -o pipefail

#bash test/testStyle.sh

echo "[testBuild][INFO]build"

docker rmi "jusito/docker-ttt:lgsm_debian" || true
docker build -t "jusito/docker-ttt:lgsm_debian" "./lgsm/"

docker rmi "jusito/docker-ttt:gmod_debian" || true
docker build -t "jusito/docker-ttt:gmod_debian" "./gmod/"

docker rmi "jusito/docker-ttt:gmod_ttt_debian" || true
docker build -t "jusito/docker-ttt:gmod_ttt_debian" "./TTT/"


echo "[testRun][INFO]running"
if ! docker run -ti --name "JusitoTesting" --rm -e TEST_MODE=true -e DEBUGGING="$DEBUGGING" "jusito/docker-ttt:gmod_ttt_debian"; then
	echo "[testRun][ERROR]run test failed for docker-ttt:ubuntu"
	exit 1
fi
docker stop "JusitoTesting" || true
docker rm "JusitoTesting" || true