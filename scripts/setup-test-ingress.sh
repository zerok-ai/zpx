#!/bin/bash
THIS_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $THIS_DIR/variables.sh

if ! [ -z ${PX_DOMAIN} ]
then
        rm $SCRIPTS_DIR/modified/cloud_ingress_grpcs_test.yaml
        cp $SCRIPTS_DIR/originals2/cloud_ingress_grpcs_test.yaml $SCRIPTS_DIR/modified/

        sed -i '' -e "s/_HTTPS_/$1/" $SCRIPTS_DIR/modified/cloud_ingress_grpcs_test.yaml
        sed -i '' -e "s/_GRPCS_/$2/" $SCRIPTS_DIR/modified/cloud_ingress_grpcs_test.yaml
        sed -i '' -e "s/_VIZIER_/$3/" $SCRIPTS_DIR/modified/cloud_ingress_grpcs_test.yaml
        sed -i '' -e "s/_AUTH_/$4/" $SCRIPTS_DIR/modified/cloud_ingress_grpcs_test.yaml

fi

