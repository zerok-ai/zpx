#!/bin/bash

kustomize build $PIXIE_DIR/k8s/cloud_deps/base/elastic/operator | kubectl apply -f -
kustomize build $PIXIE_DIR/k8s/cloud_deps/public | kubectl apply -f -
kustomize build $PIXIE_DIR/k8s/cloud/public/ | kubectl apply -f -
