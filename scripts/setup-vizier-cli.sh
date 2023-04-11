#!/bin/bash
## Variables
THIS_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $THIS_DIR/variables.sh


## Setup pixie repo
cd $PIXIE_DIR
if [[ -d $PIXIE_DIR ]]; then
    git checkout .
else
    git clone https://github.com/pixie-io/pixie.git $PIXIE_DIR
fi

export LATEST_CLOUD_RELEASE=$(git tag | grep 'release/cloud/prod'  | sort -r | head -n 1 | awk -F/ '{print $NF}')
echo "LATEST_CLOUD_RELEASE=$LATEST_CLOUD_RELEASE"
git checkout "release/cloud/prod/${LATEST_CLOUD_RELEASE}"
perl -pi -e "s|newTag: latest|newTag: \"${LATEST_CLOUD_RELEASE}\"|g" k8s/cloud/public/kustomization.yaml

## Modifying Vizier kustomize
rm $SCRIPTS_DIR/modified/image-prefix.yaml
envsubst < $SCRIPTS_DIR/originals/image-prefix.yaml >> $SCRIPTS_DIR/modified/image-prefix.yaml

echo "" >> $PIXIE_DIR/k8s/vizier/persistent_metadata/kustomization.yaml
echo "transformers:" >> $PIXIE_DIR/k8s/vizier/persistent_metadata/kustomization.yaml
echo "- image-prefix.yaml" >> $PIXIE_DIR/k8s/vizier/persistent_metadata/kustomization.yaml
cp $SCRIPTS_DIR/modified/image-prefix.yaml $PIXIE_DIR/k8s/vizier/persistent_metadata/image-prefix.yaml

## Deploy Vizier
kubectl apply -k $PIXIE_DIR/k8s/vizier/persistent_metadata/
