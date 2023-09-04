#!/bin/bash
THIS_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $THIS_DIR/variables.sh

echo ''
echo '-----------------SETTING-UP-PX-DEV-SCRIPTS-----------------'

getUserInput "Do you want to setup px dev scripts?" ""
retval=$?
PX_DEV_SCRIPTS_SETUP=$retval

if [ "$PX_DEV_SCRIPTS_SETUP" == '1' ]
then
    rm -rf $PIXIE_DIR/zerok
    mkdir -p $PIXIE_DIR/zerok
    if [ "$ZK_PROD" == '0' ]
    then
        cp $SCRIPTS_DIR/keys/zk-dev-instance.json $PIXIE_DIR/zerok/
    else
        cp $SCRIPTS_DIR/keys/zk-dev-instance-prod.json $PIXIE_DIR/zerok/zk-dev-instance.json
    fi
    cp ~/.kube/config $PIXIE_DIR/zerok/
    touch $PIXIE_DIR/zerok/postsetup.sh

    envsubst < $SCRIPTS_DIR/post-dev-setup.sh >> $PIXIE_DIR/zerok/postsetup.sh
    envsubst < $SCRIPTS_DIR/post-dev-setup-px-operator.sh >> $PIXIE_DIR/zerok/postsetup-operator.sh
    envsubst < $SCRIPTS_DIR/post-dev-setup-vizier.sh >> $PIXIE_DIR/zerok/postsetup-vizier.sh
fi

