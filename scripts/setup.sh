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

##Presetup Backend
$SCRIPTS_DIR/presetup-backend.sh

##Setup Backend
$SCRIPTS_DIR/setup-backend.sh

##Setup Operator
$SCRIPTS_DIR/setup-operator.sh

# ##Postsetup Backend
# $SCRIPTS_DIR/postsetup-backend.sh

## PX Vizier setup
if [ "$PIXIE_VIZIER_DEV_MODE" == "1" ]
then
     $OPERATOR_SCRIPTS_DIR/setup-vizier.sh
fi
