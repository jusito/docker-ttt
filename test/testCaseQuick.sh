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

bash test/testBuild.sh


echo "[testRun][INFO]running"
if ! docker run -ti --name "JusitoTesting" --rm -e TEST_MODE=true -e DEBUGGING="$DEBUGGING" -e SERVER_PASSWORD="testpw" -e SERVER_MAX_PLAYERS="10" "jusito/docker-ttt:gmod_ttt_debian"; then
	echo "[testRun][ERROR]run test failed for docker-ttt:gmod_ttt_debian"
	exit 1
fi
docker stop "JusitoTesting" || true
docker rm "JusitoTesting" || true