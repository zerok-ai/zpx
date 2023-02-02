#!/bin/bash
THIS_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $THIS_DIR/variables.sh

## PX Operator setup
if [ "$SAME_CLUSTER_SETUP" == '1' ]
then
     $OPERATOR_SCRIPTS_DIR/setup-px-operator.sh
fi
