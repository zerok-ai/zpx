#!/bin/bash
THIS_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $THIS_DIR/variables.sh

API_KEY=$(extract_auth_token abc)
px auth login --api_key $API_KEY


