# Homelab - ArgoCD + Jellyfin

This repository is a small homelab setup focused on GitOps and Kubernetes deployments. The recommended path is to manage the environment through ArgoCD, with Jellyfin as the primary application.

## Current recommendation

The recommended approach for this project is:

- Use ArgoCD as the main deployment and sync tool.
- Keep Jellyfin as the primary media application.
- Store persistent data on host paths rather than relying on a complex storage layer.
- Treat qBittorrent and Docker Compose layouts as optional or experimental components, not as the default production path.

In other words, the project is currently centered on a simple Kubernetes-based media stack, with Jellyfin being the main service.

## Overview

The stack combines:

- ArgoCD for application synchronization and automation.
- A Jellyfin Helm chart from the official upstream project.
- Custom values in this repository to fit the local environment.
- Host-based persistence for configuration and media folders.

## Repository structure

- `argocd/argocd-root-app.yaml` — root ArgoCD application that points to the apps folder.
- `argocd/apps/` — application definitions managed by ArgoCD.
- `argocd/config/jellyfin/values.yaml` — Jellyfin Helm values for this environment.
- `setup/install_argo.sh` — installs ArgoCD and applies the root application.
- `setup/argo-values.yaml` — NodePort configuration for ArgoCD service exposure.
- `setup/setup_folders.sh` — creates the host directories used by Jellyfin.
- `docker-compose/` — local Docker Compose setup for experimental use only.
- `qbittorrent/` — optional folder kept separate from the main recommended path for now.

## Architecture principles

- GitOps first: the repository is the source of truth for the environment.
- Jellyfin is the primary application in the `media` namespace.
- The setup is intentionally simple and easy to reason about.
- Optional components remain isolated and do not define the default stack.

## Requirements

- A working Kubernetes cluster (k3s or similar is fine)
- `kubectl` installed and configured
- `helm` installed
- Docker optional, only for local Compose-based experiments

## Recommended host folders

The current Jellyfin configuration relies on these host paths:

- `/srv/homelab/config/jellyfin`
- `/srv/homelab/data/media`
- `/srv/homelab/data/media/movies`
- `/srv/homelab/data/media/series`
- `/srv/homelab/data/media/animes`

Create them with:

```bash
bash setup/setup_folders.sh
```

## ArgoCD installation

The repository includes a basic install script for ArgoCD:

```bash
bash setup/install_argo.sh
```

This script does the following:

```bash
kubectl create namespace argocd
helm repo add argo https://argoproj.github.io/argo-helm
helm upgrade --install -n argocd -f ./setup/argo-values.yaml argocd argo/argo-cd
kubectl apply -f argocd/argocd-root-app.yaml
```

## Accessing ArgoCD

The ArgoCD server is exposed via NodePort using the settings from `setup/argo-values.yaml`.

- HTTPS: `https://<node-ip>:30443`

The current values use `nodePortHttps: 30443` and `nodePortHttp: 30080`.

## Accessing Jellyfin

The Jellyfin service is exposed via NodePort with the values defined in `argocd/config/jellyfin/values.yaml`.

- HTTP: `http://<node-ip>:30096`

The application is deployed in the `media` namespace.

## Docker Compose note

The Docker Compose folder is kept as a local or experimental setup only. It is not the primary lifecycle path for this repository and should not be treated as the default deployment model for the homelab.

## qBittorrent note

The qBittorrent-related files still exist in the repository, but they are currently considered optional and outside the main recommended project flow. They should be treated as separate work or a future integration path rather than the core of this homelab.

## Current status

This repository is in an early but organized phase of homelab setup. The main direction is:

- ArgoCD
- Kubernetes
- Jellyfin
- persistent host storage

The optional Compose and qBittorrent pieces are retained for experimentation and future expansion, but not as the primary recommendation.
