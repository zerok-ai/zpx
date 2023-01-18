#!/bin/bash

kubectl create namespace plc
$PIXIE_DIR/scripts/create_cloud_secrets.sh
# TODO: Create PR for self-hosted-pixie setup