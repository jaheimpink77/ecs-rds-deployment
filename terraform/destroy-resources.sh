#!/usr/bin/env bash
set -euo pipefail

APPLY_ORDER=(
    vpc ecr github-oidc alb service-discovery frontend-sg
    backend-sg rds ecs-cluster ecs-backend ecs-frontend
    monitoring budget
)

SKIP=(ecr budget github-oidc)

CI_MODE="${CI:-}"

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEV_DIR="$ROOT/dev"

ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
if [[ "$CI_MODE" = "true" ]]; then
  echo "CI MODE: destroying all components except ${SKIP[*]} in account $ACCOUNT_ID"
else
  echo "About to destroy ALL components in account $ACCOUNT_ID (eu-west-2)."
  read -r -p "Type account ID to confirm: " REPLY
  [[ "$REPLY" == "$ACCOUNT_ID" ]] || { echo "Aborted."; exit 1; }
fi

export TF_VAR_image_tag="destroy"

for (( i=${#APPLY_ORDER[@]}-1; i>=0; i-- )); do
  component="${APPLY_ORDER[$i]}"

  if [[ " ${SKIP[*]} " == *" $component "* ]]; then
    echo "=== Skipping $component (kept) ==="
    continue
  fi

  echo "=== Destroying $component ==="
  terraform -chdir="$DEV_DIR/$component" init -input=false -reconfigure
  terraform -chdir="$DEV_DIR/$component" destroy -input=false -auto-approve
done

echo "All components destroyed."