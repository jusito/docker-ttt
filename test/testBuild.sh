#!/bin/bash

readonly SUFFIX="$1"
readonly BUILD_LGSM="$(grep -qF -e '--skip-lgsm' <<< "$@" && echo false || echo true)"
readonly PUSH="$(grep -qF -e '--push' <<< "$@" && echo true || echo false)"
readonly repository="${DOCKER_REPO:-jusito/docker-ttt}"

if [ "${DEBUGGING}" = "true" ]; then
	set -o xtrace
else
	DEBUGGING="false"
fi

set -o errexit
set -o nounset
set -o pipefail

function process() {
	tag_prefix="$1"
	subdir="$2"

	docker rmi "$repository:$tag_prefix${SUFFIX}" || true
	docker build --no-cache -t "$repository:$tag_prefix${SUFFIX}" "$subdir"
	if "$PUSH"; then
		docker push "$repository:$tag_prefix${SUFFIX}"
	fi
}

echo "[testBuild][INFO] build"

if "$BUILD_LGSM"; then
	process "lgsm_debian" "lgsm/"
fi
process "gmod_debian" "gmod/"
process "gmod_ttt_debian" "TTT/"

docker rmi "$repository:latest${SUFFIX}" || true
docker tag "$repository:gmod_ttt_debian${SUFFIX}" "$repository:latest${SUFFIX}"
if "$PUSH"; then
	docker push "$repository:lgsm_debian${SUFFIX}"
fi

echo "[testBuild][INFO] build done!"
