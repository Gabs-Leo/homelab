#!/bin/bash
k create namespace argocd
helm upgrade --install -n argocd -f setup/argo-values.yaml argocd argo/argo-cd