#!/usr/bin/env bash
# Build, push and deploy python-app to Kubernetes.
# Usage: ./deploy.sh <registry> [tag]
#   ./deploy.sh myregistry.azurecr.io
#   ./deploy.sh 123456789012.dkr.ecr.us-east-1.amazonaws.com 1.0.1
set -euo pipefail

REGISTRY="${1:?Usage: ./deploy.sh <registry> [tag]}"
TAG="${2:-1.0.0}"
IMAGE="$REGISTRY/python-app:$TAG"
cd "$(dirname "$0")"

echo ">> Building $IMAGE"
docker build -t "$IMAGE" .

echo ">> Pushing $IMAGE"
docker push "$IMAGE"

echo ">> Deploying to namespace python-app"
kubectl apply -f k8s/namespace.yaml
sed "s#your-registry/python-app:1.0.0#$IMAGE#g" k8s/deployment.yaml | kubectl apply -f -
kubectl apply -f k8s/service.yaml

kubectl -n python-app rollout status deployment/python-app --timeout=180s
kubectl -n python-app get pods,svc
