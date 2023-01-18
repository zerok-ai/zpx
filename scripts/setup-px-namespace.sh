#!/bin/bash
echo ''
echo '-----------------SETTING-UP-PX-NAMESPACE-----------------'
getUserInput "Do you want to setup the px namespace" ""
retval=$?
SETUP_PX_NAMESPACE=$retval

if [ "$SETUP_PX_NAMESPACE" == '1' ]
then
    kubectl create namespace plc
    $PIXIE_DIR/scripts/create_cloud_secrets.sh
    # TODO: Create PR for self-hosted-pixie setup
fi

