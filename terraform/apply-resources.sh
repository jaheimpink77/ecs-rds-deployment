#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DEV_DIR="$ROOT/terraform/dev"
REGION="eu-west-2"
TAG="${1:-}"
if [[ -z "$TAG" ]]; then
  git -C "$ROOT" fetch --quiet origin master
  TAG="$(git -C "$ROOT" rev-parse origin/master)"
  echo "No tag given, using origin/master: $TAG"
fi

APPLY_ORDER=(
    vpc ecr github-oidc alb service-discovery frontend-sg
    backend-sg rds ecs-cluster ecs-backend ecs-frontend
    monitoring budget
)

NEEDS_TFVARS=(monitoring budget)

REPOS=(ecs-rds-deployment-backend ecs-rds-deployment-frontend)

for c in "${NEEDS_TFVARS[@]}"; do
  if [[ ! -f "$DEV_DIR/$c/terraform.tfvars" ]]; then
    echo "Missing $DEV_DIR/$c/terraform.tfvars" >&2
    exit 1
  fi
done

ACCOUNT_ID="$(aws sts get-caller-identity --query Account --output text)"
echo "About to apply ALL components in account $ACCOUNT_ID ($REGION), image tag $TAG."
read -r -p "Type the account ID to continue: " CONFIRM
if [[ "$CONFIRM" != "$ACCOUNT_ID" ]]; then
  echo "Aborted."
  exit 1
fi

require_images() {
    local repo
    for repo in "${REPOS[@]}"; do
      if ! aws ecr describe-images \
          --repository-name "$repo" \
          --region "$REGION" \
          --image-ids imageTag="$TAG" >/dev/null; then
        echo "ECR repo $repo has no image tagged $TAG (CI pushes it on merge to master)." >&2
        exit 1
      fi
    done
}

total=${#APPLY_ORDER[@]}
i=0
export TF_VAR_image_tag="$TAG"
for component in "${APPLY_ORDER[@]}"; do
  i=$((i + 1))
  if [[ "$component" == "ecs-backend" ]]; then
    require_images
  fi
  echo "==> [$i/$total] applying $component"
  terraform -chdir="$DEV_DIR/$component" init -input=false -reconfigure
  terraform -chdir="$DEV_DIR/$component" apply -input=false -auto-approve
done

echo "All $total components applied."
