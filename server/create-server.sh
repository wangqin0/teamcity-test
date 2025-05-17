#!/bin/bash

# Get the directory of the script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p $SCRIPT_DIR/server/data
mkdir -p $SCRIPT_DIR/server/logs

docker run --name teamcity-server-instance \
-v $SCRIPT_DIR/server/data:/data/teamcity_server/datadir \
-v $SCRIPT_DIR/server/logs:/opt/teamcity/logs \
-p 8111:8111 \
jetbrains/teamcity-server
