#!/bin/bash

if [ "${DEBUGGING}" = "true" ]; then
	set -o xtrace
fi

set -o errexit
set -o pipefail

echo "starting entrypoint.sh"
set -e


#start cron
bash "/home/initCron.sh"

exec /bin/bash