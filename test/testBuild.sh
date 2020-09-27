#!/bin/bash

readonly SUFFIX="$1"
readonly SKIP_LGSM="$2"

if [ "${DEBUGGING}" = "true" ]; then
	set -o xtrace
else
	DEBUGGING="false"
fi

set -o errexit
set -o nounset
set -o pipefail

echo "[testBuild][INFO]build"

if [ "$SKIP_LGSM" = true ]; then
	docker rmi "jusito/docker-ttt:lgsm_debian${SUFFIX}" || true
	docker build --no-cache -t "jusito/docker-ttt:lgsm_debian${SUFFIX}" "lgsm/"
fi

docker rmi "jusito/docker-ttt:gmod_debian${SUFFIX}" || true
docker build --no-cache -t "jusito/docker-ttt:gmod_debian${SUFFIX}" "gmod/"

docker rmi "jusito/docker-ttt:gmod_ttt_debian${SUFFIX}" || true
docker build --no-cache -t "jusito/docker-ttt:gmod_ttt_debian${SUFFIX}" "TTT/"

docker rmi "$DOCKER_REPO:latest${SUFFIX}" || true
docker tag "$DOCKER_REPO:gmod_ttt_debian${SUFFIX}" "$DOCKER_REPO:latest${SUFFIX}"