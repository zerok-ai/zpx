#!/bin/bash
THIS_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $THIS_DIR/variables.sh

AUTH_TOKEN=$(extract_auth_token abc)
echo $AUTH_TOKEN | pbcopy
px auth login --manual


