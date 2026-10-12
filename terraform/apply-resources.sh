#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DEV_DIR="$ROOT/terraform/dev"
REGION="eu-west-2"

APPLY_ORDER=(
    vpc ecr alb service-discovery frontend-sg
    backend-sg rds ecs-cluster ecs-backend
    ecs-frontend monitoring budget
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
echo "About to apply ALL components in account $ACCOUNT_ID ($REGION)."
read -r -p "Type the account ID to continue: " CONFIRM
if [[ "$CONFIRM" != "$ACCOUNT_ID" ]]; then
  echo "Aborted."
  exit 1
fi

require_images() {
    local repo count
    for repo in "${REPOS[@]}"; do
      count="$(aws ecr list-images \
        --repository-name "$repo" \
        --region "$REGION" \
        --query 'length(imageIds)' \
        --output text)"
      if [[ "$count" -eq 0 ]]; then
        echo "ECR repo $repo has no images. Run push-images-to-ecr.sh <tag> first." >&2
        exit 1
      fi
    done
}

total=${#APPLY_ORDER[@]}
i=0
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
