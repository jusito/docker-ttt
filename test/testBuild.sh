#!/bin/bash

if [ "${DEBUGGING}" = "true" ]; then
	set -o xtrace
else
	DEBUGGING="false"
fi

set -o errexit
set -o nounset
set -o pipefail

echo "[testBuild][INFO]build"

docker rmi "jusito/docker-ttt:lgsm_debian" || true
docker build --no-cache -t "jusito/docker-ttt:lgsm_debian" "lgsm/"

docker rmi "jusito/docker-ttt:gmod_debian" || true
docker build --no-cache -t "jusito/docker-ttt:gmod_debian" "gmod/"

docker rmi "jusito/docker-ttt:gmod_ttt_debian" || true
docker build --no-cache -t "jusito/docker-ttt:gmod_ttt_debian" "TTT/"