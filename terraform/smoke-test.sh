#!/usr/bin/env bash

set -euo pipefail

BASE="${1:?usage: $0 <base-url, e.g. http://my-alb.eu-west-2.elb.amazonaws.com>}"
BASE="${BASE%/}"
RETRIES="${SMOKE_RETRIES:-30}"
UNIQUE="smoke-${GITHUB_RUN_ID:-local}-${GITHUB_RUN_ATTEMPT:-0}-${RANDOM}"
TMP="$(mktemp)"
trap 'rm -f "$TMP"' EXIT

fail() { echo "FAIL: $*" >&2; exit 1; }
pass() { echo "ok:   $*" >&2; }

wait_for() {
  curl -fsS -o /dev/null --max-time 10 \
    --retry "$RETRIES" --retry-delay 10 --retry-all-errors "$1" \
    || fail "$1 never returned 2xx"
}

wait_for "$BASE/health"
pass "frontend /health"
wait_for "$BASE/api/health"
curl -fsS --max-time 10 "$BASE/api/health" | jq -e '.status == "ok"' >/dev/null \
  || fail "/api/health did not report status ok"
pass "backend /api/health through the proxy (runs a database query)"

curl -fsS --max-time 10 -o "$TMP" "$BASE/" || fail "could not fetch the index page"
bundles="$(grep -oE '/assets/[^"]+\.js' "$TMP" | sort -u || true)"
[[ -n "$bundles" ]] || fail "the index page references no JavaScript bundle"
while IFS= read -r bundle; do
  curl -fsS --max-time 30 -o "$TMP" "$BASE$bundle" || fail "could not fetch $bundle"
  if grep -q 'api\.realworld\.io' "$TMP"; then
    fail "$bundle contains the demp API address (was VITE_API_URL set at build time?)"
  fi
done <<< "$bundles"
pass "bundle does not point at the demo API"

email="${UNIQUE}@example.com"
payload="$(jq -n --arg u "$UNIQUE" --arg e "$email" \
  '{user: {username: $u, email: $e, password: "Smoke-test-pw-1"}}')"
status="$(curl -sS --max-time 20 -o "$TMP" -w '%{http_code}' \
  -X POST "$BASE/api/users" -H 'Content-Type: application/json' -d "$payload")"
[[ "$status" == "201" ]] || fail "signup returned HTTP $status: $(cat "$TMP")"
token="$(jq -er '.user.token' "$TMP")" || fail "signup response had no token"
pass "signup returned 201 and a token"


status="$(curl -sS --max-time 20 -o "$TMP" -w '%{http_code}' \
  "$BASE/api/user" -H "Authorization: Token $token")"
[[ "$status" == "200" ]] || fail "GET /api/user returned HTTP $status: $(cat "TMP")"
jq -e --arg e "$email" '.email == $e' "$TMP" >/dev/null \
  || fail "/api/user did not return $email. Body; $(cat "$TMP")"
pass "authenticated read returned the new user"

echo "All smoke checks passed against $BASE"