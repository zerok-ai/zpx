#!/bin/bash

echo ''
echo '-----------------VALIDATING-ENV-VARIABLES-----------------'

echo 'Env variables set'
echo '-----------------'
echo "PX_DOMAIN is $PX_DOMAIN"
echo "USE_MKCERT_CA is $USE_MKCERT_CA"
echo "SAME_CLUSTER_SETUP is $SAME_CLUSTER_SETUP"
# echo "PIXIE_DEV_MODE is $PIXIE_DEV_MODE"
echo "PIXIE_OPERATOR_DEV_MODE is $PIXIE_OPERATOR_DEV_MODE"
echo "PIXIE_HOST_DEV_MODE is $PIXIE_HOST_DEV_MODE"
echo "PIXIE_VIZIER_DEV_MODE is $PIXIE_VIZIER_DEV_MODE"
echo "PIXIE_REPO is $PIXIE_REPO"
echo "VIZIER_ARTIFACT_REPO is $VIZIER_ARTIFACT_REPO"
echo "ZONE is $ZONE"
echo "CLUSTER_NAME is $CLUSTER_NAME"
echo "PX_CLUSTER_NAME is $PX_CLUSTER_NAME"
echo "CLUSTER_INSTANCE_TYPE is $CLUSTER_INSTANCE_TYPE"
echo "CLUSTER_NUM_NODES is $CLUSTER_NUM_NODES"

##export ZONE=us-west1-b
##export CLUSTER_NAME=testpxsetup
##export PX_DOMAIN=pxtest.getanton.com

if [ -z "$CLUSTER_NAME" ] || [ -z "$ZONE" ]
then
	echo "Required environment variables are not set. Please set them and try again"
	#TODO
	exit 99
fi