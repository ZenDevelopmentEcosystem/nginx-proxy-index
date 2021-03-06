#!/bin/bash
set -e

# Warn if the DOCKER_HOST socket does not exist
if [[ $DOCKER_HOST = unix://* ]]; then
	socket_file=${DOCKER_HOST#unix://}
	if ! [ -S "$socket_file" ]; then
		cat >&2 <<-EOT
			ERROR: you need to share your Docker host socket with a volume at $socket_file
			Typically you should run your NPI-server with: \`-v /var/run/docker.sock:$socket_file:ro\`
			See the documentation.
		EOT
		socketMissing=1
	fi
fi

# If the user has run the default command and the socket doesn't exist, fail
if [ "$socketMissing" = 1 ] && [ "$1" = forego ] && [ "$2" = start ] && [ "$3" = '-r' ]; then
	exit 1
fi

exec "$@"
