#!/bin/bash
THIS_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $THIS_DIR/variables.sh

echo 'Removing ingress-nginx'
kubectl delete namespace ingress-nginx
echo 'plc'
kubectl delete namespace plc
echo 'Removing cert-manager'
kubectl delete -f https://github.com/cert-manager/cert-manager/releases/download/vX.Y.Z/cert-manager.yaml
echo 'Removing elastic-system'
kubectl delete namespace elastic-system
echo 'Removing pixie repo directory'
rm -rf $PIXIE_DIR
# kubectl delete namespace cert-manager
# kubectl delete clusterissuer letsencrypt-cluster-issuer
echo 'Removing modified ingress and cert files'
rm $SCRIPTS_DIR/modified/cloud_ingress_*.yaml
rm $SCRIPTS_DIR/modified/certificate_*.yaml
echo 'Removing px operator'
px delete
