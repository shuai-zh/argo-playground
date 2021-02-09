#!/bin/bash -e

# install asdf plugins and cli tools
asdf plugin add kind || echo 'skipping'
asdf plugin add argo || echo 'skipping'
asdf install
kind create cluster --name argo-playground --config kind-config.yaml || echo 'skipping'

# install helm charts
helm repo add argo https://argoproj.github.io/argo-helm
helm upgrade --install --atomic argo-workflows argo/argo -n argo-workflows -f helm/charts/argo-workflows/values.yaml --create-namespace
helm upgrade --install --atomic argo-events argo/argo-events -n argo-events -f helm/charts/argo-events/values.yaml --create-namespace
helm upgrade --install --atomic argo-cd argo/argo-cd -n argo-cd -f helm/charts/argo-cd/values.yaml --create-namespace

# update k8s resources
kubectl create clusterrolebinding default-admin --clusterrole cluster-admin --serviceaccount=default:default || echo 'skipping'
kubectl patch svc argo-workflows-server -n argo-workflows --type='json' -p='[{"op": "replace", "path": "/spec/ports/0/nodePort", "value": 30000}]'
kubectl patch svc argo-cd-argocd-server -n argo-cd --type='json' -p='[{"op": "replace", "path": "/spec/ports/0/nodePort", "value": 30001}, {"op": "replace", "path": "/spec/ports/1/nodePort", "value": 30002}]'

echo "Done!🎉"
