#!/bin/bash -e

asdf plugin add kind || true
asdf plugin add argo || true
asdf install
kind create cluster --name argo-playground --config kind-config.yaml || true
kubectl create clusterrolebinding default-admin --clusterrole cluster-admin --serviceaccount=default:default || true
helm repo add argo https://argoproj.github.io/argo-helm
helm upgrade --install --atomic argo-workflows argo/argo -n argo-workflows -f helm/charts/argo-workflows/values.yaml --create-namespace
helm upgrade --install --atomic argo-events argo/argo-events -f helm/charts/argo-events/values.yaml
kubectl patch svc argo-workflows-server -n argo-workflows --type='json' -p='[{"op": "replace", "path": "/spec/ports/0/nodePort", "value": 30000}]'
echo "Done!"
