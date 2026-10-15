#!/bin/bash
kubectl create namespace argocd
helm repo add argo https://argoproj.github.io/argo-helm
helm upgrade --install -n argocd -f ./setup/argo-values.yaml argocd argo/argo-cd
kubectl apply -f argocd/argocd-root-app.yaml