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

##Create px namespace
$SCRIPTS_DIR/setup-px-namespace.sh

##Secrets Setup
if [ "$USE_MKCERT_CA" == '0' ]
then
     $SCRIPTS_DIR/setup-secrets.sh
fi

##INGRESS setup
$SCRIPTS_DIR/setup-ingress.sh

if [ "$PIXIE_DEV_MODE" == '1' ]
then
     $SCRIPTS_DIR/setup-px-dev-scripts.sh
fi

##PIXIE Remaining setup
if [ "$USE_MKCERT_CA" == '1' ]
then
     echo ''
     echo '-----------------SETTING-UP-ETC-HOSTS-----------------'

     getUserInput "Do you want to add the nginx the /etc/hosts record?" ""
     retval=$?
     ETC_HOSTS_SETUP=$retval

     if [ "$ETC_HOSTS_SETUP" == '1' ]
     then
          echo 'This requires sudo password as we will modify the /etc/hosts.'
          sudo $SCRIPTS_DIR/setup-etc-hosts.sh
     fi
fi

if [ "$PIXIE_HOST_DEV_MODE" == '1' ] || [ "$PIXIE_OPERATOR_DEV_MODE" == '1' ] || [ "$PIXIE_VIZIER_DEV_MODE" == '1' ]
then
     $SCRIPTS_DIR/setup-px-dev-scripts.sh
fi

##PIXIE Core setup
$SCRIPTS_DIR/setup-pxhost-core.sh

##PIXIE Remaining setup
$SCRIPTS_DIR/setup-pxhost-remaining.sh

##PIXIE Exposing Kratos
$SCRIPTS_DIR/setup-expose-kratos.sh
