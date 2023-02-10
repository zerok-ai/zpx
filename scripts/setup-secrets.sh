#!/bin/bash
THIS_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $THIS_DIR/variables.sh


echo ''
echo '-----------------SETTING-UP-SECRETS-----------------'
getUserInput "Do you want to setup the secrets" ""
retval=$?
SECRETS_SETUP=$retval

if [ "$SECRETS_SETUP" == '1' ]
then

	FOUND_LETSENCRYPT_CLUSTERISSUER='0'

	clusterissuers=($(kubectl get clusterissuer --no-headers | awk '{print $1}'))
	for i in "${!clusterissuers[@]}"; do
		if [[ ${clusterissuers[i]} == "letsencrypt-cluster-issuer" ]]; then
			FOUND_LETSENCRYPT_CLUSTERISSUER='1'
		fi
	done

	if [ "$FOUND_LETSENCRYPT_CLUSTERISSUER" == '0' ]
	then
		echo 'ClusterIssuer is not present. Creating one...'
		kubectl apply -f $SCRIPTS_DIR/yamls/clusterissuer.yaml
	fi

	FOUND_PLC_CERTIFICATE='0'
	FOUND_NGINX_CERTIFICATE='0'
	CERTIFICATES_COUNT=0
	ADD_WAIT_TIME='0'

	certificates=($(kubectl get certificates -A --no-headers | awk '{print $2}'))
	for i in "${!certificates[@]}"; do
		if [[ ${certificates[i]} == "cloud-proxy-tls-certs" ]]; then
			((CERTIFICATES_COUNT++))
		fi

		# if [[ ${certificates[i]} == "cloud-proxy-tls-certs-nginx" ]]; then
		#    ((CERTIFICATES_COUNT++))
		# fi
	done

	if [[ $ABC -lt 2 ]]
	then
		kubectl apply -f $SCRIPTS_DIR/modified/certificate_cloud_proxy_tls_certs.yaml
		kubectl apply -f $SCRIPTS_DIR/modified/certificate_cloud_proxy_tls_certs_nginx.yaml
		ADD_WAIT_TIME='1'
	fi

	# if [ "$FOUND_PLC_CERTIFICATE" == '0' ]
	# then
	# 	echo 'cloud-proxy-tls-certs is not present. Creating one...'
	# 	kubectl apply -f $SCRIPTS_DIR/modified/certificate_cloud_proxy_tls_certs.yaml
	# 	ADD_WAIT_TIME='1'
	# fi

	# if [ "$FOUND_NGINX_CERTIFICATE" == '0' ]
	# then
	# 	echo 'cloud-proxy-tls-certs-nginx is not present. Creating one...'
	# 	kubectl apply -f $SCRIPTS_DIR/modified/certificate_cloud_proxy_tls_certs_nginx.yaml
	# 	ADD_WAIT_TIME='1'
	# fi

	if [ "$ADD_WAIT_TIME" == '1' ]
	then
		echo "Waiting for the secrets to come up... (wait time $SETUP_SECRETS_WAIT_TIME seconds)"
		spinner sleep $SETUP_SECRETS_WAIT_TIME
	fi
fi



