#!/bin/bash

if [ "${DEBUGGING:?}" = "true" ]; then
	set -o xtrace
fi

set -o errexit
set -o nounset
set -o pipefail

docker rmi "jusito/docker-ttt:ubuntu" || true
docker build -t "jusito/docker-ttt:ubuntu" "."