# Argo Playground with Kind k8s

## Prerequisite

[asdf-vm](https://asdf-vm.com/)

## Setup

### TLDR;

Run `./start.sh`

### Manual

1. Install `kind` and `argo` CLI with `asdf`: `asdf plugin add kind; asdf plugin add argo; asdf install`
2. Create a kind cluster with `kind create cluster --name argo-playground --config kind-config.yaml`
3. Create a `ClusterRoleBinding` with `kubectl create clusterrolebinding default-admin --clusterrole cluster-admin --serviceaccount=default:default`
4. Add the Argo Helm repo with `helm repo add argo https://argoproj.github.io/argo-helm`
5. Install `Argo Workflows` Helm chart with `helm upgrade --install --atomic argo-workflows argo/argo -n argo-workflows -f helm/charts/argo-workflows/values.yaml --create-namespace`
6. Install `Argo Events` Helm chart with `helm upgrade --install --atomic argo-events argo/argo-events -f helm/charts/argo-events/values.yaml`
7. Change the NodePort host port to `30000` (defined in `./kind-config.yaml`) with `kubectl patch svc argo-workflows-server -n argo-workflows --type='json' -p='[{"op": "replace", "path": "/spec/ports/0/nodePort", "value": 30000}]'`

## Get Started

1. Visit http://localhost:30000/ in your browser and start exploring
2. [Optional] Submit a test workflow with `argo submit https://raw.githubusercontent.com/argoproj/argo/master/examples/hello-world.yaml --watch`

## Cleanup

Run `./cleanup.sh`
