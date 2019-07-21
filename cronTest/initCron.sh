#!/bin/sh

if [ "${DEBUGGING}" = "true" ]; then
	set -o xtrace
fi

set -o errexit
set -o pipefail
set -o nounset

#set up cronjob
rm -f "$STEAM_PATH/lgsm-cronjobs" || true
touch "$STEAM_PATH/lgsm-cronjobs"
# false positive
echo "*/1 * * * * date >> date.log" >> "$STEAM_PATH/lgsm-cronjobs" # out on release
echo "" >> "$STEAM_PATH/lgsm-cronjobs"
