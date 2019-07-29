#!/bin/sh

if [ "${DEBUGGING}" = "true" ]; then
	set -o xtrace
fi

set -o errexit
set -o pipefail
set -o nounset

wget -qO "apparmor.profile" 'https://raw.githubusercontent.com/moby/moby/master/profiles/apparmor/template.go'

