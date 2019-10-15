#!/bin/sh

if [ "${DEBUGGING}" = "true" ]; then
	set -o xtrace
fi

set -o errexit
set -o nounset

name=$1
command=$2
file="/usr/local/bin/$name"

echo "[createAlias.sh] $name = $command"

if [ -f "$file" ]; then
	echo "[createAlias.sh]error file already exists => cant create alias with this method"
else
	echo '#!/bin/bash' > "$file"
	echo "$command" >> "$file" && \
	chmod a=rx "$file"
fi
