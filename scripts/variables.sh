#!/usr/bin/env bash
export ZONE=us-west1-b
export CLUSTER_NAME=testpxsetup2
export CLUSTER_NUM_NODES=2
export CLUSTER_INSTANCE_TYPE=e2-standard-4
export PX_DOMAIN=pxtest2.getanton.com

THIS_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
export SCRIPTS_DIR=$THIS_DIR
export ZPX_DIR="$(dirname "$SCRIPTS_DIR")"
export PIXIE_DIR=$ZPX_DIR/build/pixie

export SETUP_NGINX_INGRESS_WAIT_TIME=30
export SETUP_SECRETS_WAIT_TIME=35
export SETUP_CERT_MANAGER_WAIT_TIME=15

getUserInput(){
    read -p "$1 $2? [y/n]" -rn1 response
    echo " "
    retval=0;
    if  [[ $response =~ ^[Yy]$ ]] ;then
        retval=1;    
    fi
    return "$retval"
}
export -f getUserInput

function spinner(){
    $SCRIPTS_DIR/spinner.sh $@
}
export -f spinner