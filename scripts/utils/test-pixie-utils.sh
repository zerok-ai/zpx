#!/bin/bash
THIS_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $THIS_DIR/pixie-utils.sh $1 $2
TMP_DIR=$THIS_DIR/.tmp

# PX_DOMAIN=testpxsetup7.testdomain.com
PX_DOMAIN=$1

validateResponseStatus $TMP_DIR/headers2.txt
echo $?
