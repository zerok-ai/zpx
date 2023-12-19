setup-cloud:
	CLUSTER_NAME=testacloud01 \
	ASK_USER=1 \
	SETUP_CLUSTER=1 \
	ASK_GRAVITON=0 \
	FORCE_DISABLE_PX_OPERATOR=1 \
	ZPIXIE_BRANCH=logless \
	DNS_ZONE=zerok-dev \
	./scripts/setup.sh

setup-cluster:
	CLUSTER_NAME=testacloud01 \
	ASK_USER=1 \
	SETUP_CLUSTER=1 \
	ASK_GRAVITON=0 \
	DNS_ZONE=anton \
	./scripts/setup-cluster.sh

setup-nginx:
	CLUSTER_NAME=testacloud01 \
	ASK_USER=1 \
	DNS_ZONE=anton \
	./scripts/setup-nginx-ingress.sh

setup-cert-manager:
	CLUSTER_NAME=testacloud01 \
	ASK_USER=1 \
	DNS_ZONE=anton \
	./scripts/setup-cert-manager.sh

setup-cluster-issuer:
	kubectl apply -f ./scripts/yamls/clusterissuer.yaml


setup-cluster-full: setup-cluster setup-nginx setup-cert-manager setup-cluster-issuer