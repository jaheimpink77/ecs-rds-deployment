#!/usr/bin/env bash
set -euo pipefail

ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
REGISTRY=$ACCOUNT_ID.dkr.ecr.eu-west-2.amazonaws.com
TAG="${1:?usage: $0 <tag>, e.g. v0.1.0}"

aws ecr get-login-password --region eu-west-2 \
  | docker login --username AWS --password-stdin $REGISTRY

docker build --platform linux/amd64 -t "$REGISTRY/ecs-rds-deployment-backend:$TAG" ../backend
docker build --platform linux/amd64 -t "$REGISTRY/ecs-rds-deployment-frontend:$TAG" ../frontend

docker push "$REGISTRY/ecs-rds-deployment-backend:$TAG"
docker push "$REGISTRY/ecs-rds-deployment-frontend:$TAG"
