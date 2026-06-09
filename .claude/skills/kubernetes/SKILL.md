---
name: kubernetes
description: kubectl commands for managing the aks-demo Kubernetes cluster and demo-app deployment.
---

# Kubernetes Skill

## Context

```bash
# Get AKS credentials (sets kubectl context)
az aks get-credentials --resource-group rg-aks-demo --name aks-demo

# Show current context
kubectl config current-context

# List contexts
kubectl config get-contexts
```

## Pods

```bash
# List pods
kubectl get pods

# List pods with more detail
kubectl get pods -o wide

# Describe a pod
kubectl describe pod <pod-name>

# Get pod logs
kubectl logs <pod-name>

# Follow logs
kubectl logs -f <pod-name>

# Exec into pod
kubectl exec -it <pod-name> -- /bin/sh
```

## Deployments

```bash
# List deployments
kubectl get deployments

# Describe deployment
kubectl describe deployment demo-app

# Check rollout status
kubectl rollout status deployment/demo-app

# Rollback to previous version
kubectl rollout undo deployment/demo-app

# Scale deployment
kubectl scale deployment demo-app --replicas=3

# Update image
kubectl set image deployment/demo-app demo-app=acraksdemocap.azurecr.io/demo-app:<tag>
```

## Services

```bash
# List services
kubectl get svc

# Get external IP
kubectl get svc demo-app -o jsonpath='{.status.loadBalancer.ingress[0].ip}'

# Describe service
kubectl describe svc demo-app
```

## Apply Manifests

```bash
# Apply all manifests in k8s/
kubectl apply -f k8s/

# Apply single file
kubectl apply -f k8s/deployment.yaml

# Delete resources
kubectl delete -f k8s/
```

## Debugging

```bash
# Get events (useful for troubleshooting)
kubectl get events --sort-by=.lastTimestamp

# Check resource usage
kubectl top pods
kubectl top nodes

# Get all resources
kubectl get all
```

## Namespaces

```bash
# List namespaces
kubectl get namespaces

# Create namespace
kubectl create namespace prod

# Set default namespace
kubectl config set-context --current --namespace=prod
```
