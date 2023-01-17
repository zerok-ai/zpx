#!/bin/bash
THIS_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $THIS_DIR/variables.sh


STAGE=$1

echo ''
echo '-----------------SETTING-UP-PIXIE-INGRESS-----------------'
getUserInput "Do you want to setup the pixie cloud ingress?" ""
retval=$?
CLOUD_INGRESS_SETUP=$retval

if [ "$CLOUD_INGRESS_SETUP" == '1' ]
then
	if [ -z "$STAGE" ]
	then
		STAGE="predeploy"
	fi

	# kubectl apply -f $SCRIPTS_DIR/modified/cloud_ingress_https.yaml

	kubectl apply -f $SCRIPTS_DIR/modified/cloud_ingress_$STAGE.yaml	
	
fi




