# Operations Guide

This document covers operational procedures for the DevOps ecosystem.

## Prerequisites

- Docker Desktop (for local builds)
- kubectl (for Kubernetes deployments)
- Helm 3+ (for chart rendering)
- PowerShell (for automation scripts)

---

## GHCR Image Pull Secret

The Helm charts reference `imagePullSecrets: ghcr-secret` for pulling images from GitHub Container Registry (GHCR). Create this secret in each namespace before deploying:

```bash
kubectl create secret docker-registry ghcr-secret \
  --namespace=default \
  --docker-server=ghcr.io \
  --docker-username=YOUR_GITHUB_USERNAME \
  --docker-password=YOUR_GITHUB_PAT
```

For a Personal Access Token (PAT):
1. GitHub → Settings → Developer settings → Personal access tokens
2. Create a token with `read:packages` scope
3. Use the token as `--docker-password`

Repeat for other namespaces (e.g., `argocd`, `monitoring`) if needed.

---

## Scripts Usage

| Script | Purpose |
|--------|---------|
| `scripts/build-and-test.ps1` | Build and test both microservices locally (run from repo root or `scripts/`) |
| `scripts/promote-to-stage.ps1` | Promote an image tag to Stage environment |
| `scripts/deploy-prod.ps1` | Blue-Green or Canary production deployment (mock) |
| `scripts/create-pr.ps1` | Create a PR via GitHub API (requires `GITHUB_TOKEN`) |
| `scripts/verify-live.ps1` | Verify live stack with Docker Compose |

---

## Kubernetes Structure

- **`k8s/charts/`** — Helm charts (ms-a, ms-b). **ArgoCD syncs from this path**.
- **`k8s/envs/`** — Standalone manifests for direct apply (ms-a, ms-b, ingresses).
- **`k8s/argocd/`** — ArgoCD Application definitions.

ArgoCD uses `k8s/charts` with `directory.recurse: true` to deploy both microservice charts.

---

## Monitoring (Grafana)

- **`k8s/charts/grafana-values.yaml`** — Values file for the Grafana Helm chart (e.g., via `helm install grafana grafana/grafana -f k8s/charts/grafana-values.yaml`).
- **`k8s/envs/monitoring-ingress.yaml`** — Ingress for Grafana in the `monitoring` namespace (references `prometheus-grafana`; adjust service name if using standalone Grafana chart).

To deploy Grafana separately:
```bash
helm repo add grafana https://grafana.github.io/helm-charts
helm install grafana grafana/grafana -f k8s/charts/grafana-values.yaml -n monitoring
```
