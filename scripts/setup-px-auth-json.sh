#!/bin/bash
THIS_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $THIS_DIR/variables.sh

rm ~/.pixie/auth.json
AUTHJSON=$($SCRIPTS_DIR/pixie-ui-cli.sh -c authjson)
echo $AUTHJSON >> ~/.pixie/auth.json
# cat ~/.pixie/auth.json