#!/bin/bash
set -eu

# Docker available? Otherwise exit
docker info > /dev/null 2>&1 || { echo "WARNING: docker not available!!" 2>&1; exit 0; }

exec docker run \
  --mount "type=bind,source=${PWD},target=/${PWD},readonly" \
  --workdir "/${PWD}" \
  --rm \
  -i \
  "${EXPORTED_DOCKER_REGISTRY:-}hadolint/hadolint:latest" \
  hadolint \
  "$@"
