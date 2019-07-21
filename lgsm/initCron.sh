#!/bin/sh

if [ "${DEBUGGING}" = "true" ]; then
	set -o xtrace
fi

set -o errexit
set -o pipefail
set -o nounset

LOG_PATH="$STEAM_PATH/logs"
CRON="$LOG_PATH/lgsm.cron"
CRON_LOG="$LOG_PATH/cron.log"

#set up cronjob
mkdir "$LOG_PATH" || true
rm -f "$CRON" || true
touch "$CRON"
# false positive
# shellcheck disable=SC2129
echo "$CRON_MONITOR $STEAM_PATH/gmodserver monitor > '$LOG_PATH/monitor.log' 2>&1" >> "$CRON"
# shellcheck disable=SC2129
echo "$CRON_UPDATE $STEAM_PATH/gmodserver update > '$LOG_PATH/update.log' 2>&1" >> "$CRON"
# shellcheck disable=SC2129
echo "$CRON_FORCE_UPDATE $STEAM_PATH/gmodserver force-update >'$LOG_PATH/force-update.log' 2>&1" >> "$CRON"
# shellcheck disable=SC2129
echo "$CRON_LOG_ROTATE mv -f '$CRON_LOG' '${CRON_LOG}.old'" >> "$CRON"
echo "" >> "$CRON"

if [ -e "$CRON_LOG" ]; then
	mv -f "$CRON_LOG" "${CRON_LOG}.old"
fi

supercronic "$CRON" 2> "$LOG_PATH/cron.log" &