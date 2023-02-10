#!/bin/bash
THIS_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $THIS_DIR/variables.sh

## PX Operator setup
$OPERATOR_SCRIPTS_DIR/setup-px-operator.sh
