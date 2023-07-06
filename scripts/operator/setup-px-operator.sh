#!/bin/bash
echo ''
echo '-----------------SETTING-UP-PX-OPERATOR-----------------'
getUserInput "Do you want to setup the px operator on the cluster ${PX_CLUSTER_NAME}" "" $FORCE_ASK_PX_OPERATOR
retval=$?
PX_OPERATOR_SETUP=$retval

if [ "$PX_OPERATOR_SETUP" == '1' ]
then

    $SCRIPTS_DIR/check-and-wait-for-pods.sh plc
    if [ "$SAME_CLUSTER_SETUP" == '0' ]
    then
        echo "Switching k8s context to the $PX_CLUSTER_NAME"
        gcloud container clusters get-credentials $PX_CLUSTER_NAME --zone $ZONE --project $PX_CLUSTER_PROJECT
        DEV_CLOUD_NAMESPACE=""
    else
        DEV_CLOUD_NAMESPACE="--dev_cloud_namespace plc"
    fi

    if [ "$PIXIE_OPERATOR_DEV_MODE" == '1' ]
    then
        # APIKEY=$($SCRIPTS_DIR/pixie-ui-cli.sh -c apikey)
        AUTHJSON=$($SCRIPTS_DIR/pixie-ui-cli.sh -c authjson)
        rm $PIXIE_DIR/zerok/auth.json
        echo $AUTHJSON >> $PIXIE_DIR/zerok/auth.json
        $PIXIE_DIR/scripts/run_docker.sh "sh ./zerok/postsetup-operator.sh build"
    else
        # API_KEY=$($SCRIPTS_DIR/pixie-ui-cli.sh -c apikey)
        # if [ -z "$API_KEY" ]
        # then
        #     API_KEY=$($SCRIPTS_DIR/pixie-ui-cli.sh -c apikey)
        # fi
        # echo "API_KEY = $API_KEY"
        # px auth login --api_key $API_KEY
        $SCRIPTS_DIR/setup-px-auth-json.sh
        px deploy $DEV_CLOUD_NAMESPACE
    fi
fi


