#!/bin/bash
THIS_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $THIS_DIR/variables.sh

helpFunction()
{
   echo ""
   echo 'Usage: $0 [options]
         Options are listed below:
         -i {command | instance-name} \t\t\t\t\t//instances
         -r \t\t\t\t\t//start client replay
         -k \t\t\t\t\t//kills the egress replay'

   exit 1 # Exit script after printing help
}

while [ $# -ne 0 ]; do
    case "$1" in
        -h)
             helpFunction
             exit 2
             ;;
        -*)
             echo "Unknown option: $1" >&2
             helpFunction
             exit 2
             ;;
        *)
             break
             ;;
    esac
done

##Validate environment variables
$SCRIPTS_DIR/validate-env-variables.sh

##Cluster setup
$SCRIPTS_DIR/setup-cluster.sh $CLUSTER_NAME

##Setting up pixie repo, if required or forced
$SCRIPTS_DIR/setup-pixie-repo.sh

##Nginx Ingress setup
$SCRIPTS_DIR/setup-nginx-ingress.sh
#TODO: Use kustomize to pickup nginx-ingress from nginx and add relevant aerguments

##DNS setup
$SCRIPTS_DIR/setup-dns.sh

##DOMAIN setup
$SCRIPTS_DIR/setup-domain.sh
#TODO: Use kustomize

kubectl create namespace plc
$PIXIE_DIR/scripts/create_cloud_secrets.sh
# TODO: Create PR for self-hosted-pixie setup

##CERT-MANAGER
$SCRIPTS_DIR/setup-cert-manager.sh

##Secrets Setup
$SCRIPTS_DIR/setup-secrets.sh

##INGRESS setup
$SCRIPTS_DIR/setup-ingress.sh

##PIXIE Remaining setup
$SCRIPTS_DIR/setup-remaining.sh



