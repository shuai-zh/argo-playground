#!/bin/bash -e

asdf plugin add kind || echo 'skipping'
asdf plugin add argo || echo 'skipping'
asdf install
kind create cluster --name argo-playground --config kind-config.yaml || echo 'skipping'
kubectl create clusterrolebinding default-admin --clusterrole cluster-admin --serviceaccount=default:default || echo 'skipping'
helm repo add argo https://argoproj.github.io/argo-helm
helm upgrade --install --atomic argo-workflows argo/argo -n argo -f helm/charts/argo-workflows/values.yaml --create-namespace
helm upgrade --install --atomic argo-events argo/argo-events -n argo -f helm/charts/argo-events/values.yaml --create-namespace
kubectl patch svc argo-workflows-server -n argo --type='json' -p='[{"op": "replace", "path": "/spec/ports/0/nodePort", "value": 30000}]'
echo "Done!🎉"
