#!/bin/bash
THIS_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $THIS_DIR/variables.sh
echo ''
echo '-----------------SETTING-UP-CLUSTER-----------------'
getUserInput "Do you want to setup the cluster ${CLUSTER_NAME}" ""
retval=$?
CLUSTER_SETUP=$retval

if [ "$ASK_GRAVITON" == '1' ]
then
     getUserInput "Graviton Cluster?" ""
     retval=$?
     GRAVITON_CLUSTER=$retval
else
     GRAVITON_CLUSTER=0
fi

baseInstanceType=$CLUSTER_INSTANCE_TYPE
resolvedZone=$ZONE
if [ "$GRAVITON_CLUSTER" == '1' ]
then
     baseInstanceType=$CLUSTER_GRAVITON_INSTANCE_TYPE
     resolvedZone=$GRAVITON_ZONE
fi

CLUSTER_TOBE_CREATED=$CLUSTER_NAME
if [ -z $1 ]
then
     CLUSTER_TOBE_CREATED=$CLUSTER_NAME
else
     CLUSTER_TOBE_CREATED=$1
fi

SPOT_COMMAND=""
if [ "$SPOT" == '1' ]
then
     SPOT_COMMAND="--preemptible"
fi

if [ "$CLUSTER_SETUP" == '1' ]
then

     gcloud container clusters create $CLUSTER_TOBE_CREATED $SPOT_COMMAND --num-nodes=$CLUSTER_NUM_NODES --machine-type=$baseInstanceType --zone=$resolvedZone --no-enable-cloud-logging --no-enable-cloud-monitoring
     if [ "$GRAVITON_CLUSTER" == '1' ]
     then
          gcloud container node-pools create x86-node-pool --cluster=$1 --num-nodes=1 --machine-type=$CLUSTER_INSTANCE_TYPE --zone=$resolvedZone
     fi
fi


