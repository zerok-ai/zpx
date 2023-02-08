#!/bin/bash
THIS_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $THIS_DIR/variables.sh

echo ''
echo '-----------------SETTING-UP-REMAINING-PX-HOST-SERVICES-----------------'
getUserInput "Do you want to setup the remaining px host services" ""
retval=$?
SETUP_REM_PX_HOST=$retval

if [ "$SETUP_REM_PX_HOST" == '1' ]
then
    kustomize build $PIXIE_DIR/k8s/cloud_deps/base/elastic/operator | kubectl apply -f -
    kustomize build $PIXIE_DIR/k8s/cloud_deps/public | kubectl apply -f -
    if [ "$PIXIE_DEV_MODE" == '0' ]
    then
        echo "PIXIE Dev Mode is disabled"
        kustomize build $PIXIE_DIR/k8s/cloud/public/ | kubectl apply -f -
    else
        echo "PIXIE Dev Mode is enabled"
        $PIXIE_DIR/scripts/run_docker.sh "sh ./zerok/postsetup.sh"
        # echo "Waiting for the pixie services to come up (Wait time ~4 minutes)"
	    # $SCRIPTS_DIR/check-and-wait-for-pods.sh plc
        # APIKEY=$($SCRIPTS_DIR/pixie-ui-cli.sh -c apikey)
        # $PIXIE_DIR/scripts/run_docker.sh "sh ./zerok/postsetup-operator.sh $APIKEY"
    fi
fi
