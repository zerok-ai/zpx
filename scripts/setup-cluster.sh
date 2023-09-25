#!/bin/bash
echo ''
echo '-----------------SETTING-UP-CLUSTER-----------------'
getUserInput "Do you want to setup the cluster ${CLUSTER_NAME}" ""
retval=$?
CLUSTER_SETUP=$retval

getUserInput "Graviton Cluster?" ""
retval=$?
GRAVITON_CLUSTER=$retval

baseInstanceType=$CLUSTER_INSTANCE_TYPE
resolvedZone=$ZONE
if [ "$GRAVITON_CLUSTER" == '1' ]
then
     baseInstanceType=$CLUSTER_GRAVITON_INSTANCE_TYPE
     resolvedZone=$GRAVITON_ZONE
fi

if [ "$CLUSTER_SETUP" == '1' ]
then
     # gcloud container clusters create $1 --num-nodes=$CLUSTER_NUM_NODES --machine-type=$baseInstanceType --zone=$resolvedZone --no-enable-cloud-logging --no-enable-cloud-monitoring

     if [ "$GRAVITON_CLUSTER" == '1' ]
     then
          gcloud container node-pools create x86-node-pool --cluster=$1 --num-nodes=1 --machine-type=$CLUSTER_INSTANCE_TYPE --zone=$resolvedZone
     fi
fi


