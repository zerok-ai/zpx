#!/bin/bash
THIS_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $THIS_DIR/variables.sh

echo ''
echo '-----------------SETTING-UP-NGINX-INGRESS-----------------'
getUserInput "Do you want to setup the nginx-ingress?" ""
retval=$?
NGINX_INGRESS_SETUP=$retval

if [ "$NGINX_INGRESS_SETUP" == '1' ]
then
    kubectl create clusterrolebinding cluster-admin-binding \
        --clusterrole cluster-admin \
        --user $(gcloud config get-value account)
    URL=https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.5.1/deploy/static/provider/cloud/deploy.yaml
    curl $URL --output $SCRIPTS_DIR/yamls/nginx-ingress/nginx-ingress.yaml
    kubectl apply -k $SCRIPTS_DIR/yamls/nginx-ingress-overlays/
    # kubectl apply -f $SCRIPTS_DIR/yamls/nginx-ingress.yaml
   
    echo "Waiting for the nginx-ingress service to come up... (wait time $SETUP_NGINX_INGRESS_WAIT_TIME seconds)"
    echo $(date +%s)
    spinner sleep $SETUP_NGINX_INGRESS_WAIT_TIME
    echo $(date +%s)
    kubectl delete -A ValidatingWebhookConfiguration ingress-nginx-admission

fi





