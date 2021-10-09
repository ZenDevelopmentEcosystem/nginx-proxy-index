#!/usr/bin/env bash
# Test if file has executable bit set.

set -eu -o pipefail

[ -x "$1" ] || { echo "File '$1' is missing executable bit."; exit 1; }
