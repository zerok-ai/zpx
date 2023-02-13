#!/bin/bash
THIS_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $THIS_DIR/variables.sh


# $SCRIPTS_DIR/check-and-wait-for-pods.sh pl
$SCRIPTS_DIR/setup-ingress.sh deploy