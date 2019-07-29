#!/bin/bash

if [ "${DEBUGGING:?}" = "true" ]; then
	set -o xtrace
fi

set -o errexit
set -o nounset
set -o pipefail

docker exec -it CONTAINER ./home/steam/gmodserver details

Status: OFFLINE -> fail Health