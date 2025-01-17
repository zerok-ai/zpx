#!/bin/bash
export DOLLAR='$'
THIS_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
# PIXIE_DIR="$(dirname "$${ESC}THIS_DIR")"
PIXIE_DIR=$${ESC}THIS_DIR

# APIKEY=$${ESC}1
# echo "APIKEY = $${ESC}APIKEY"

echo "THIS_DIR = $${ESC}THIS_DIR"
echo "PIXIE_DIR = $${ESC}PIXIE_DIR"

mkdir -p ~/.kube
cp $${ESC}THIS_DIR/zerok/config ~/.kube/

git config --global --add safe.directory $${ESC}PIXIE_DIR
export PL_CLOUD_ADDR=$PX_DOMAIN:443
# export PL_TESTING_ENV=dev
export CLUSTER_ZEROK_PL=$CLUSTER_NAME
perl -pi -e "s|newTag: latest|newTag: \"\"|g" $${ESC}PIXIE_DIR/k8s/cloud/public/kustomization.yaml
perl -pi -e "s|pixie-prod|pixie-dev|g" $${ESC}PIXIE_DIR/k8s/cloud/public/kustomization.yaml
skaffold config set default-repo $PIXIE_REPO

echo "docker login with service account"
gcloud auth activate-service-account $GCLOUD_SERVICE_ACCOUNT \
   --key-file=$${ESC}PIXIE_DIR/zerok/zk-dev-instance.json
gcloud auth print-access-token | docker login -u oauth2accesstoken \
   --password-stdin https://us-west1-docker.pkg.dev

# echo "Switching k8s context to the $${ESC}CLUSTER_ZEROK_PL"
# gcloud container clusters get-credentials $${ESC}CLUSTER_ZEROK_PL --zone $ZONE --project $PX_CLUSTER_PROJECT

# echo "Setting up remaining services"
# skaffold run -f $${ESC}PIXIE_DIR/skaffold/skaffold_cloud.yaml -p public
echo "Switching k8s context to the $PX_CLUSTER_NAME"
gcloud container clusters get-credentials $PX_CLUSTER_NAME --zone $ZONE --project $PX_CLUSTER_PROJECT
echo "Setting up px"
mkdir -p ~/.pixie
rm ~/.pixie/auth.json
cp $${ESC}THIS_DIR/zerok/auth.json ~/.pixie/
# bazel run //src/pixie_cli:px -- auth login --api_key $${ESC}APIKEY
bazel run //src/pixie_cli:px -- deploy