#!/bin/bash

if [ "${DEBUGGING}" = "true" ]; then
	set -o xtrace
fi

set -o errexit
set -o nounset
set -o pipefail

#bash test/testStyle.sh

echo "[testBuild][INFO]build docker-ttt:ubuntu"
docker rmi "jusito/docker-ttt:ubuntu" || true
docker build -t "jusito/docker-ttt:ubuntu" "."
echo "[testRun][INFO]running docker-ttt:ubuntu"
if ! docker run -ti --name "JusitoTesting" --rm -e TEST_MODE=true -e DEBUGGING="${DEBUGGING}" "jusito/docker-ttt:ubuntu"; then
	echo "[testRun][ERROR]run test failed for docker-ttt:ubuntu"
	exit 1
fi
docker stop "JusitoTesting" || true
docker rm "JusitoTesting" || true