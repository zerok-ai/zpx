#!/usr/bin/env bash
export ASK_USER=1
export FORCE_ASK_PX_OPERATOR=1
export SETUP_CLUSTER=1

#Are we going to setup px operator in the same cluster as px host?
export USE_MKCERT_CA=0
export SAME_CLUSTER_SETUP=1
export PIXIE_HOST_DEV_MODE=0
export PIXIE_OPERATOR_DEV_MODE=0
export PIXIE_VIZIER_DEV_MODE=1
export PIXIE_VIZIER_BUILD=1
export PIXIE_VIZIER_DEPLOY=1
export PIXIE_REPO=us-west1-docker.pkg.dev/zerok-dev/pixie-test-dev
export ZPIXIE_BRANCH=deploy-main

#Basic cluster parameters
export ZONE=us-west1-b

if [[ -z $ZPIXIE_REPO ]]; then
    export ZPIXIE_REPO=git@github.com:zerok-ai/zpixie.git
fi

echo "ZPIXIE_REPO==$ZPIXIE_REPO"

if [[ -z $CLUSTER_NAME ]]; then
    export CLUSTER_NAME=avinpx07
fi

export PX_CLUSTER_NAME=avinpx07
export PX_CLUSTER_PROJECT=zerok-dev
export CLUSTER_NUM_NODES=2
export PX_CLUSTER_PROJECT=zerok-dev
export CLUSTER_INSTANCE_TYPE=e2-standard-4

#PX Domain to be used
# export NGINX_INGRESS_CONTROLLER_SERVICE_URL=ingress-nginx-controller.ingress-nginx.svc.cluster.local
export NGINX_INGRESS_CONTROLLER_SERVICE_URL=cloud-proxy-service.plc.svc.cluster.local
# Cloud proxy service domain
# Port forward
if [ "$SAME_CLUSTER_SETUP" == '1' ]
then
    export PX_CLUSTER_NAME=$CLUSTER_NAME
fi

if [ "$USE_MKCERT_CA" == '1' ]
then
    export PX_DOMAIN=$CLUSTER_NAME.testdomain.com
else
    export PX_DOMAIN=px.$CLUSTER_NAME.getanton.com
fi

export PL_CLOUD_ADDR=$PX_DOMAIN

if [ "$PIXIE_OPERATOR_DEV_MODE" == '1' ]
then
    export PL_CLOUD_ADDR=$PX_DOMAIN:443
    export PL_TESTING_ENV=dev
fi


THIS_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
export SCRIPTS_DIR=$THIS_DIR
export UTILS_DIR=$THIS_DIR/utils
export OPERATOR_SCRIPTS_DIR=$THIS_DIR/operator
export PATCHES_DIR=$THIS_DIR/patches
export ZPX_DIR="$(dirname "$SCRIPTS_DIR")"
export PIXIE_DIR=$ZPX_DIR/build/pixie

export SETUP_NGINX_INGRESS_WAIT_TIME=40
export EXPOSE_KRATOS_WAIT_TIME=40
export SETUP_SECRETS_WAIT_TIME=50
export SETUP_CERT_MANAGER_WAIT_TIME=20

getUserInput(){
    FORCE_ASK=$3
    if [ -z "$FORCE_ASK" ]
    then
        FORCE_ASK=0
    fi
    if [ "$ASK_USER" == '0' ] && [ "$FORCE_ASK" == "0" ]
    then
        retval=1;
    else
        read -p "$1 $2? [y/n]" -rn1 response
        echo " "
        retval=0;
        if  [[ $response =~ ^[Yy]$ ]] ;then
            retval=1;
        fi
    fi
    

    return "$retval"
}
export -f getUserInput

function spinner(){
    $SCRIPTS_DIR/spinner.sh $@
}
export -f spinner

function extract_auth_token(){
    DEBUG_LOGS=$1
    if [ -z "$DEBUG_LOGS" ]
    then
        DEBUG_LOGS=0
    fi
    ABC=$($UTILS_DIR/extract-auth-token.sh $PX_DOMAIN $DEBUG_LOGS)
    echo $ABC
}
export -f extract_auth_token
