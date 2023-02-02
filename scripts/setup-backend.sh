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
if [ "$SAME_CLUSTER_SETUP" == '0' ]
then
     $SCRIPTS_DIR/setup-secrets.sh
fi

##INGRESS setup
# if [ "$SAME_CLUSTER_SETUP" == '0' ]
# then
$SCRIPTS_DIR/setup-ingress.sh
# fi

if [ "$PIXIE_DEV_MODE" == '1' ]
then
     $SCRIPTS_DIR/setup-px-dev-scripts.sh
fi

##PIXIE Remaining setup
$SCRIPTS_DIR/setup-remaining-pxhost.sh

##PIXIE Remaining setup
if [ "$SAME_CLUSTER_SETUP" == '1' ]
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

spinner sleep 42