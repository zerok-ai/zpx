#!/bin/bash
echo ''
echo '-----------------SETTING-UP-PX-NAMESPACE-----------------'
getUserInput "Do you want to setup the px namespace" ""
retval=$?
SETUP_PX_NAMESPACE=$retval

if [ "$SETUP_PX_NAMESPACE" == '1' ]
then
    kubectl create namespace plc
    echo "creating cloud secrets "
    sed -i 's/set -e/set -x/' $PIXIE_DIR/scripts/create_cloud_secrets.sh
    sed -i 's/urandom tr -dc \'a-zA-Z0-9\' | fold -w 64 | head -n 1/urandom tr -dc \'a-zA-Z0-9\'/' $PIXIE_DIR/scripts/create_cloud_secrets.sh
    $PIXIE_DIR/scripts/create_cloud_secrets.sh
    echo "done creating cloud secrets "
    # TODO: Create PR for self-hosted-pixie setup
fi

