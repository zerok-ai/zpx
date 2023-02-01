#!/bin/bash
THIS_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $THIS_DIR/variables.sh

echo ''
echo '-----------------SETTING-UP-PX-NAMESPACE-----------------'
getUserInput "Do you want to setup the px namespace" ""
retval=$?
SETUP_PX_NAMESPACE=$retval

if [ "$SETUP_PX_NAMESPACE" == '1' ]
then
    echo "YES"
else
    echo "NO"
fi

