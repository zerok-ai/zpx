#!/bin/bash
echo ''
echo '-----------------SETTING-UP-PX-VIZIER-----------------'
getUserInput "Do you want to setup the px vizier (in DEV mode) on the cluster ${PX_CLUSTER_NAME}" ""
retval=$?
PX_VIZIER_SETUP=$retval

if [ "$PX_VIZIER_SETUP" == '1' ]
then

    $SCRIPTS_DIR/check-and-wait-for-pods.sh pl
    
    if [ "$SAME_CLUSTER_SETUP" == '0' ]
    then
        echo "Switching k8s context to the $PX_CLUSTER_NAME"
        gcloud container clusters get-credentials $PX_CLUSTER_NAME --zone $ZONE --project $PX_CLUSTER_PROJECT
    fi

    $PIXIE_DIR/scripts/run_docker.sh "sh ./zerok/postsetup-vizier.sh"
fi


