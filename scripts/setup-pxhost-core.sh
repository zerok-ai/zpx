#!/bin/bash
THIS_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $THIS_DIR/variables.sh

echo ''
echo '-----------------SETTING-UP-CORE-PX-HOST-SERVICES-----------------'
getUserInput "Do you want to setup the core px host services" ""
retval=$?
SETUP_CORE_PX_HOST=$retval

if [ "$SETUP_CORE_PX_HOST" == '1' ]
then
    kustomize build $PIXIE_DIR/k8s/cloud_deps/base/elastic/operator | kubectl apply -f -
    kustomize build $PIXIE_DIR/k8s/cloud_deps/public | kubectl apply -f -
fi
