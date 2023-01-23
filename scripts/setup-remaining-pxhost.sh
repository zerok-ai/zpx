#!/bin/bash
THIS_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $THIS_DIR/variables.sh

echo ''
echo '-----------------SETTING-UP-REMAINING-PX-HOST-SERVICES-----------------'
getUserInput "Do you want to setup the remaining px host services" ""
retval=$?
SETUP_REM_PX_HOST=$retval

if [ "$SETUP_REM_PX_HOST" == '1' ]
then
    kustomize build $PIXIE_DIR/k8s/cloud_deps/base/elastic/operator | kubectl apply -f -
    kustomize build $PIXIE_DIR/k8s/cloud_deps/public | kubectl apply -f -
    if [ "$PIXIE_DEV_MODE" == '0' ]
    then
        kustomize build $PIXIE_DIR/k8s/cloud/public/ | kubectl apply -f -
    else
        perl -pi -e "s|newTag: latest|newTag: \"\"|g" $PIXIE_DIR/k8s/cloud/public/kustomization.yaml
        perl -pi -e "s|pixie-prod|pixie-dev|g" $PIXIE_DIR/k8s/cloud/public/kustomization.yaml
        skaffold config set default-repo us-west1-docker.pkg.dev/zerok-dev/pixie-dev
        skaffold run -f $PIXIE_DIR/skaffold/skaffold_cloud.yaml
    fi

    # if [ "$SAME_CLUSTER_SETUP" == '1' ]
    # then
    #     sudo echo "192.241.xx.xx  venus.example.com venus" >> /etc/hosts
    #     go build $PIXIE_DIR/src/utils/dev_dns_updater/dev_dns_updater.go
    #     $PIXIE_DIR/dev_dns_updater --domain-name="dev.withpixie.dev"  --kubeconfig=$HOME/.kube/config --n=plc &
    # fi
fi
