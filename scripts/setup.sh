#!/bin/bash
THIS_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $THIS_DIR/variables.sh

helpFunction()
{
   echo ""
   echo 'Usage: $0 [options]
         Options are listed below:
         -i {command | instance-name} \t\t\t\t\t//instances'

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

##DNS setup
$SCRIPTS_DIR/setup-dns.sh

##DOMAIN setup
$SCRIPTS_DIR/setup-domain.sh

##Create px namespace
$SCRIPTS_DIR/setup-px-namespace.sh

##CERT-MANAGER
$SCRIPTS_DIR/setup-cert-manager.sh

##Secrets Setup
$SCRIPTS_DIR/setup-secrets.sh

##INGRESS setup
$SCRIPTS_DIR/setup-ingress.sh

##PIXIE Remaining setup
$SCRIPTS_DIR/setup-remainingpxhost.sh

