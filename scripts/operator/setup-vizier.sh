#!/bin/bash
echo ''
echo '-----------------SETTING-UP-PX-VIZIER-----------------'

if [ "$PIXIE_VIZIER_BUILD" == "1" ]
then
    getUserInput "Do you want to build the px vizier (in DEV mode)" ""
    retval=$?
    VIZIER_BUILD_INP=$retval

    if [ "$VIZIER_BUILD_INP" == '1' ]
    then

        $SCRIPTS_DIR/setup-patches.sh
        
        if [ "$PIXIE_VIZIER_BUILD" == "1" ]
        then
            echo "Building vizier"
            $PIXIE_DIR/scripts/run_docker.sh "sh ./zerok/postsetup-vizier.sh build"
        fi
    fi
fi

if [ "$PIXIE_VIZIER_DEPLOY" == "1" ]
then
    getUserInput "Do you want to deploy the px vizier (in DEV mode) on the cluster ${PX_CLUSTER_NAME}" ""
    retval=$?
    VIZIER_DEPLOY_INP=$retval
    if [ "$VIZIER_DEPLOY_INP" == '1' ]
    then
        $SCRIPTS_DIR/check-and-wait-for-pods.sh pl

        if [ "$SAME_CLUSTER_SETUP" == '0' ]
        then
            echo "Switching k8s context to the $PX_CLUSTER_NAME"
            gcloud container clusters get-credentials $PX_CLUSTER_NAME --zone $ZONE --project $PX_CLUSTER_PROJECT
        fi

        echo "Deploying Vizier"
        kubectl apply -k $PIXIE_DIR/k8s/vizier/persistent_metadata/
    fi
fi
