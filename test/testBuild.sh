#!/bin/bash

readonly SUFFIX="$1"
readonly BUILD_LGSM="$(grep -qF '--skip-lgsm' <<< "$@" && echo false || echo true)"
readonly repository="${DOCKER_REPO:-jusito/docker-ttt}"

if [ "${DEBUGGING}" = "true" ]; then
	set -o xtrace
else
	DEBUGGING="false"
fi

set -o errexit
set -o nounset
set -o pipefail

echo "[testBuild][INFO]build"

if "$BUILD_LGSM"; then
	docker rmi "$repository:lgsm_debian${SUFFIX}" || true
	docker build --no-cache -t "$repository:lgsm_debian${SUFFIX}" "lgsm/"
fi

docker rmi "$repository:gmod_debian${SUFFIX}" || true
docker build --no-cache -t "$repository:gmod_debian${SUFFIX}" "gmod/"

docker rmi "$repository:gmod_ttt_debian${SUFFIX}" || true
docker build --no-cache -t "$repository:gmod_ttt_debian${SUFFIX}" "TTT/"

docker rmi "$repository:latest${SUFFIX}" || true
docker tag "$repository:gmod_ttt_debian${SUFFIX}" "$repository:latest${SUFFIX}"
