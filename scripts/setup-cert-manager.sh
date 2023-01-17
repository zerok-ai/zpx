#!/bin/bash

echo ''
echo '-----------------SETTING-UP-CERT-MANAGER-----------------'

FOUND_CERT_MANAGER='0'
CERT_MANAGER_READY='1'

certmanagersReady=($(kubectl get pods -n cert-manager --no-headers | awk '{print $2}'))
for i in "${!certmanagersReady[@]}"; do
	if [[ ${FOUND_CERT_MANAGER} == '0' ]]; then
		FOUND_CERT_MANAGER='1'
	fi

	if [[ ${certmanagersReady[i]} != "1/1" ]]; then
	   CERT_MANAGER_READY='0'
	fi
done

if [ "$FOUND_CERT_MANAGER" == '0' ]
then
	echo 'Cert manager was not installed. Installing now...'
	kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.11.0/cert-manager.yaml

	echo "Waiting for the cert-manager to come up... (wait time $SETUP_CERT_MANAGER_WAIT_TIME seconds)"
	spinner sleep $SETUP_CERT_MANAGER_WAIT_TIME
else
	echo 'Cert manager is installed'
fi

if [ "$CERT_MANAGER_READY" == '0' ]
then
	echo 'Cert manager is down, please look into this...'
else
	echo 'Cert manager is up and running'
fi




