#!/bin/bash
echo ''
echo '-----------------SETTING-UP-PX-OPERATOR-----------------'
getUserInput "Do you want to setup the px operator on the same cluster ${CLUSTER_NAME}" ""
retval=$?
PX_OPERATOR_SETUP=$retval

if [ "$PX_OPERATOR_SETUP" == '1' ]
then
    API_KEY=$(extract_auth_token)
    API_KEY=$(extract_auth_token)
    px auth login --api_key $API_KEY

    if [ "$SAME_CLUSTER_SETUP" == '1' ]
    then
        px deploy --dev_cloud_namespace plc
    else
        echo "Switching k8s context to the $PX_CLUSTER_NAME"
        gcloud container clusters get-credentials $PX_CLUSTER_NAME --zone $ZONE --project $PX_CLUSTER_PROJECT
        px deploy
    fi
fi


