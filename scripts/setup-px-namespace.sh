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
    $PIXIE_DIR/scripts/create_cloud_secrets.sh
#    chmod +x $SCRIPTS_DIR/create_cloud_secrets.sh
#    $SCRIPTS_DIR/create_cloud_secrets.sh
    echo "done creating cloud secrets "
    # TODO: Create PR for self-hosted-pixie setup
fi

