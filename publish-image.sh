#!/bin/bash

# Exit on error (e), error on undefined variable (u), show command to debug (x)
set -eux

# Display help text if tag not provided as first parameter
if (( $# == 0 )); then
    cat <<EOT
Publish image to Docker registry

Usage: $(basename $0) (tag) [tag 2] [tag 3] ...
EOT
    exit 1
fi

# Get the source tag of image
sourceImage="klo2k/sqlplus"
sourceTag="$1"

echo "TIME: $(date --rfc-2822)"

# For each tag, push to registry
for additionalTag  in "$@"; do
    docker tag "${sourceImage}:${sourceTag}" "${sourceImage}:${additionalTag}"
    docker push "${sourceImage}:${additionalTag}"
done

echo 'SUCCESS: Publish done'
echo "TIME: $(date --rfc-2822)"
