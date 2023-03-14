#!/bin/bash
THIS_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $THIS_DIR/variables.sh

echo ''
echo '-----------------EXPOSING-KRATOS-----------------'
getUserInput "Do you want to expose the kratos pod" ""
retval=$?
SETUP_EXPOSE_KRATOS=$retval

if [ "$SETUP_EXPOSE_KRATOS" == '1' ]
then
    echo "Waiting for the kratos service to come up... (wait time $EXPOSE_KRATOS_WAIT_TIME seconds)"
    spinner sleep $EXPOSE_KRATOS_WAIT_TIME

    kubectl apply -f $SCRIPTS_DIR/modified/expose-kratos.yaml
fi
