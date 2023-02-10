#!/bin/bash
THIS_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $THIS_DIR/pixie-create-org.sh $1 $2


if ! [ -z "$auth_orgID" ]
then
    envsubst < $THIS_DIR/auth.json.template >> $TMP_DIR/auth.json
    OUTPUT=$(cat $TMP_DIR/auth.json)
    echo $OUTPUT
fi