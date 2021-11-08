#!/bin/bash

readonly SUFFIX="$1"
readonly BUILD_LGSM="$(grep -qF '--skip-lgsm' <<< "$@" && echo false || echo true)"

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
	docker rmi "jusito/docker-ttt:lgsm_debian${SUFFIX}" || true
	docker build --no-cache -t "jusito/docker-ttt:lgsm_debian${SUFFIX}" "lgsm/"
fi

docker rmi "jusito/docker-ttt:gmod_debian${SUFFIX}" || true
docker build --no-cache -t "jusito/docker-ttt:gmod_debian${SUFFIX}" "gmod/"

docker rmi "jusito/docker-ttt:gmod_ttt_debian${SUFFIX}" || true
docker build --no-cache -t "jusito/docker-ttt:gmod_ttt_debian${SUFFIX}" "TTT/"

docker rmi "jusito/docker-ttt:latest${SUFFIX}" || true
docker tag "jusito/docker-ttt:gmod_ttt_debian${SUFFIX}" "jusito/docker-ttt:latest${SUFFIX}"
