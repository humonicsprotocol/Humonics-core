#!/usr/bin/env bash
# Clones all Humonics org repos into the current directory.
# Idempotent — skips repos that already exist.
set -euo pipefail

ORG="humonicsprotocol"
REPOS=(
  "Humonics-core"
  "Humonics-sdk"
  "Humonics-api"
  "Humonics-oracle-service"
  "Humonics-dashboard"
)

BASE_DIR="${1:-$HOME/humonics}"
mkdir -p "$BASE_DIR"

echo "Cloning Humonics repos into $BASE_DIR..."

for REPO in "${REPOS[@]}"; do
  TARGET="$BASE_DIR/$REPO"
  if [ -d "$TARGET/.git" ]; then
    echo "  ✓ $REPO already exists — skipping"
  else
    echo "  ↓ Cloning $REPO..."
    git clone "git@github.com:$ORG/$REPO.git" "$TARGET"
  fi
done

echo ""
echo "Done. Run ./scripts/bootstrap.sh to complete local setup."
