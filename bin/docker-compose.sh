#!/bin/env bash
# Run docker compose in repository context.
#
set -eu -o pipefail

PROJECT_NAME=nginx-proxy-index
ENV_FILE=./.env

ARGS=("$@")

function run-docker-compose() {
    local compose_args=()
    if [ -f "./local-docker-compose.yml" ]; then
        compose_args+=("-f" "./local-docker-compose.yml")
    fi
    compose_args+=("-f" "./docker-compose.yml")
    compose_args+=("--env-file" "${ENV_FILE}")
    compose_args+=("-p" "${PROJECT_NAME}")
    docker-compose "${compose_args[@]}" "${ARGS[@]}"
}

export HOSTNAME=${PROJECT_NAME}

run-docker-compose
