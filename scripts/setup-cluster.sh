#!/bin/bash
echo ''
echo '-----------------SETTING-UP-CLUSTER-----------------'
getUserInput "Do you want to setup the cluster ${CLUSTER_NAME}" ""
retval=$?
CLUSTER_SETUP=$retval

if [ "$CLUSTER_SETUP" == '1' ]
then
     gcloud container clusters create $1 --num-nodes=$CLUSTER_NUM_NODES --machine-type=$CLUSTER_INSTANCE_TYPE --zone=$ZONE
fi


