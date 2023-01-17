#!/bin/bash

echo ''
echo '-----------------VALIDATING-ENV-VARIABLES-----------------'

echo 'Env variables set'
echo '-----------------'
echo "PX_DOMAIN is $PX_DOMAIN"
echo "ZONE is $ZONE"
echo "CLUSTER_NAME is $CLUSTER_NAME"
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