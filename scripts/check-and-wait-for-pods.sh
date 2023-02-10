#!/bin/bash

NAMESPACE=$1
RESOURCE=pods
echo ''
echo "Waiting for the $RESOURCE to be ready in $NAMESPACE namespace"
while [[ $(kubectl get $RESOURCE -n $NAMESPACE -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') == *"False"* ]]; do echo "Waiting for pod" && sleep 5; done

