#!/bin/bash
## Variables
THIS_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $THIS_DIR/variables.sh


## Setup pixie repo
# cd $PIXIE_DIR
# if [[ -d $PIXIE_DIR ]]; then
#     git checkout .
# else
    rm -rf $PIXIE_DIR
    git clone --branch $ZPIXIE_BRANCH $ZPIXIE_REPO $PIXIE_DIR
# fi

# Required at the time of building, so commenting out
# perl -pi -e 's/dateTime: {}/envTemplate:\n      template: "{{ .VIZIER_TAG }}"/' $PIXIE_DIR/skaffold/skaffold_vizier.yaml

## Modifying Vizier kustomize
mkdir -p $SCRIPTS_DIR/modified/vizier
rm -f $SCRIPTS_DIR/modified/vizier/image-prefix.yaml
envsubst < $SCRIPTS_DIR/originals/vizier/image-prefix.yaml > $SCRIPTS_DIR/modified/vizier/image-prefix.yaml
rm -f $SCRIPTS_DIR/modified/vizier/kustomization.yaml
envsubst < $SCRIPTS_DIR/originals/vizier/kustomization.yaml > $SCRIPTS_DIR/modified/vizier/kustomization.yaml
rm -f $SCRIPTS_DIR/modified/vizier/zk-client-db-configmap.yaml
envsubst < $SCRIPTS_DIR/originals/vizier/zk-client-db-configmap.yaml > $SCRIPTS_DIR/modified/vizier/zk-client-db-configmap.yaml
cp $SCRIPTS_DIR/originals/vizier/zpixie-configmap.yaml $SCRIPTS_DIR/modified/vizier/zpixie-configmap.yaml

## Deploy Vizier
# kubectl apply -k $SCRIPTS_DIR/modified/vizier/
kustomize build $SCRIPTS_DIR/modified/vizier/ > $SCRIPTS_DIR/modified/vizier/exported-vizier.yaml
yq eval-all 'select(.kind == "DaemonSet")' $SCRIPTS_DIR/modified/vizier/exported-vizier.yaml  > $SCRIPTS_DIR/modified/vizier/exported-vizier-pem.yaml