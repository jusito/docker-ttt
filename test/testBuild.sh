#!/bin/bash

readonly SUFFIX="$1"
readonly BUILD_TTT="$(grep -qF -e '--skip-ttt' <<< "$@" && echo false || echo true)"
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
	target="$2"
	cache_option="$(grep -qF -e '--no-cache' <<< "$@" && echo "--no-cache" || echo "")"

	docker rmi "$repository:$tag_prefix${SUFFIX}" || true
	docker build --target "$target" $cache_option -t "$repository:$tag_prefix${SUFFIX}" .
	if "$PUSH"; then
		docker push "$repository:$tag_prefix${SUFFIX}"
	fi
}

echo "[testBuild][INFO] build"

process "lgsm_debian" "lgsm" --no-cache
process "gmod_debian" "gmod"
if "$BUILD_TTT"; then
	process "gmod_ttt_debian" "TTT"
fi

docker rmi "$repository:latest${SUFFIX}" || true
docker tag "$repository:gmod_ttt_debian${SUFFIX}" "$repository:latest${SUFFIX}"
if "$PUSH"; then
	docker push "$repository:latest${SUFFIX}"
fi

echo "[testBuild][INFO] build done!"
