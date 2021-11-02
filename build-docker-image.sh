#!/bin/bash

# Build container image of app

# Exit on error (e), error on undefined variable (u), show command to debug (x)
set -eux

# Go to directory of this script
cd "$(dirname $0)"

echo "INFO: Start image build - $(date --rfc-2822)"
docker build --pull \
    --label org.opencontainers.image.revision="$(git rev-parse HEAD)" \
    --tag "klo2k/sqlplus:development" \
    --file ./Dockerfile \
    .
echo "SUCCESS: Image built - $(date --rfc-2822)"
