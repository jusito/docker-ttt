#!/bin/sh

if [ "${DEBUGGING}" = "true" ]; then
	set -o xtrace
fi

set -o errexit
set -o nounset
set -o pipefail

# test sha3sums

#if ! printf '%s  %s' "$(grep -Eo "grep -Eq '\^[^\\]+" Dockerfile | sed 's/...........//')" "checkHealth.sh" | sha3sum -c ; then
#	echo "[testStyle][ERROR]Sha3sum of checkHealth.sh in Dockerfile invalid"
#	exit 2
#fi

directory="$PWD"
echo "[testStyle][INFO]workdir $directory"

check() {
	file="$1"
	exclude=""
	if [ -n "$2" ]; then
		exclude="--exclude=$2"
	fi

	echo "[testStyle][INFO]processing $file with extra arg: $exclude"
	# shellcheck disable=SC2086
	if shellcheck $exclude "$file"; then
		return 0
	else
		echo "[testStyle][ERROR]style is bad"
		return 1
	fi
}


find "${directory}" -maxdepth 1 -type f -iname '*.sh' |
while read -r filename
do
    if ! check "$filename" ''; then
		exit 1
	fi
done

# shellcheck disable=SC2181
if [ "$?" = "0" ]; then
	echo "[testStyle][INFO]all elements passed style check"
	exit 0
else
	echo "[testStyle][ERROR]style in at least one element looks bad"
	exit 1
fi