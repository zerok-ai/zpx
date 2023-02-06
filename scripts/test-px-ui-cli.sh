#!/bin/bash
THIS_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $THIS_DIR/variables.sh

# $SCRIPTS_DIR/pixie-ui-cli.sh -c apikey -l
API_KEY=$($SCRIPTS_DIR/pixie-ui-cli.sh -c apikey)
if [ -z "$API_KEY" ]
then
    API_KEY=$($SCRIPTS_DIR/pixie-ui-cli.sh -c apikey)
fi
px auth login --api_key $API_KEY


