setup-cloud:
	CLUSTER_NAME=democloud01 \
	ASK_USER=1 \
	SETUP_CLUSTER=1 \
	ASK_GRAVITON=0 \
	FORCE_DISABLE_PX_OPERATOR=1 \
	ZPIXIE_BRANCH=logless \
	DNS_ZONE=zerok-dev \
	./scripts/setup.sh

setup-cluster:
	CLUSTER_NAME=democlient01 \
	ASK_USER=1 \
	SETUP_CLUSTER=1 \
	ASK_GRAVITON=0 \
	DNS_ZONE=zerok-dev \
	./scripts/setup-cluster.sh

setup-nginx:
	CLUSTER_NAME=loadclient02 \
	ASK_USER=1 \
	DNS_ZONE=anton \
	./scripts/setup-nginx-ingress.sh

setup-cert-manager:
	CLUSTER_NAME=loadclient02 \
	ASK_USER=1 \
	DNS_ZONE=anton \
	./scripts/setup-cert-manager.sh
