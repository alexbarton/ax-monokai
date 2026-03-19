#!/usr/bin/env bash
#
# Alex' Monokai Color Scheme: AX-Monokai
# import.sh: Import a new "target", substitute colors with variables.

set -euo pipefail

if [[ $# -ne 1 ]]; then
	echo "$0 <infile>" >&2
	exit 1
fi

# Get the color variables. Sorting the colors prioritizes the "color" variables
# compared with "gray" and others.
read -ra sed_args <<<"$(grep '^[a-z]' AX-Monokai.conf | sort |
	while read -r def
do
	var="${def%% *}"
	val="${def##* }"; val="${val##*#}"
	printf -- "-e s/%s/\\\$%s/g " "${val}" "${var}"
done)"

sed "${sed_args[@]}" "$1"
