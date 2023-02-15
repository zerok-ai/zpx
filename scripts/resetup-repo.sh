#!/bin/bash
THIS_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $THIS_DIR/variables.sh

helpFunction()
{
   echo ""
   echo 'Usage: $0'

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

##Setting up pixie repo, if required or forced
$SCRIPTS_DIR/setup-pixie-repo.sh

##DOMAIN setup
$SCRIPTS_DIR/setup-domain.sh

if [ "$PIXIE_HOST_DEV_MODE" == '1' ] || [ "$PIXIE_OPERATOR_DEV_MODE" == '1' ] || [ "$PIXIE_VIZIER_DEV_MODE" == '1' ]
then
     $SCRIPTS_DIR/setup-px-dev-scripts.sh
fi
