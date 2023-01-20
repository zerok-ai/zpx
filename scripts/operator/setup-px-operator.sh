#!/bin/bash
echo ''
echo '-----------------SETTING-UP-PX-OPERATOR-----------------'
getUserInput "Do you want to setup the px operator on the same cluster ${CLUSTER_NAME}" ""
retval=$?
PX_OPERATOR_SETUP=$retval

if [ "$PX_OPERATOR_SETUP" == '1' ]
then
    px auth login
    px deploy --dev_cloud_namespace plc
fi


