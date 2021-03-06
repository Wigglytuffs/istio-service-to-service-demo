#!/bin/sh

## Download Istio
curl -L https://git.io/getLatestIstio | sh -

# Create build folder.
rm -rf build/
mkdir build

# Following the step on https://istio.io/docs/setup/kubernetes/install/helm/ for version 1.1.1
kubectl create namespace istio-system
helm template istio-1.1.1/install/kubernetes/helm/istio-init --name istio-init --namespace istio-system > build/crds.yaml
kubectl apply -f build/crds.yaml

# Wait for this output to become 53
kubectl get crds | grep 'istio.io\|certmanager.k8s.io' | wc -l

# Create template for istio install with the demo profile
helm template istio-1.1.1/install/kubernetes/helm/istio --name istio --namespace istio-system \
    --values istio-1.1.1/install/kubernetes/helm/istio/values-istio-demo.yaml > build/istio-install.yaml
    
## Install Istio based on the template.
kubectl apply -f build/istio-install.yaml