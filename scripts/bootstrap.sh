#!/usr/bin/env bash
# Full local dev bootstrap. Idempotent — safe to run multiple times.
set -euo pipefail

BASE_DIR="${1:-$HOME/humonics}"

echo "=== Humonics bootstrap ==="
echo ""

# 1. Check prerequisites
check_cmd() {
  if ! command -v "$1" &>/dev/null; then
    echo "✗ $1 not found — please install it first"
    exit 1
  fi
  echo "  ✓ $1"
}

echo "Checking prerequisites..."
check_cmd node
check_cmd npm
check_cmd git
check_cmd docker

NODE_VERSION=$(node -e "process.exit(parseInt(process.version.slice(1)) < 18 ? 1 : 0)" 2>/dev/null && echo "ok" || echo "fail")
if [ "$NODE_VERSION" = "fail" ]; then
  echo "✗ Node.js >= 18 required (found $(node --version))"
  exit 1
fi

echo ""

# 2. Clone repos if not already present
"$(dirname "$0")/setup-repos.sh" "$BASE_DIR"

echo ""

# 3. Install dependencies in each repo
REPOS=(
  "Humonics-sdk"
  "Humonics-api"
  "Humonics-oracle-service"
  "Humonics-dashboard"
)

echo "Installing dependencies..."
for REPO in "${REPOS[@]}"; do
  DIR="$BASE_DIR/$REPO"
  if [ -d "$DIR" ]; then
    echo "  → $REPO"
    (cd "$DIR" && npm install --silent)
  fi
done

echo ""

# 4. Start shared services
echo "Starting Redis via Docker..."
if docker ps --format '{{.Names}}' | grep -q "^humonics-redis$"; then
  echo "  ✓ Redis already running"
else
  docker run -d --name humonics-redis -p 6379:6379 redis:7-alpine
  echo "  ✓ Redis started on localhost:6379"
fi

echo ""

# 5. Copy .env.example files
echo "Setting up .env files..."
for REPO in "${REPOS[@]}"; do
  DIR="$BASE_DIR/$REPO"
  ENV_EXAMPLE="$DIR/.env.example"
  ENV_FILE="$DIR/.env"
  if [ -f "$ENV_EXAMPLE" ] && [ ! -f "$ENV_FILE" ]; then
    cp "$ENV_EXAMPLE" "$ENV_FILE"
    echo "  ✓ $REPO/.env created from .env.example"
  elif [ -f "$ENV_FILE" ]; then
    echo "  ✓ $REPO/.env already exists — skipping"
  fi
done

echo ""
echo "=== Bootstrap complete ==="
echo ""
echo "Next steps:"
echo "  1. Fill in .env files in each repo (API keys, contract addresses)"
echo "  2. cd $BASE_DIR/Humonics-sdk && npm test"
echo "  3. cd $BASE_DIR/Humonics-api && npm test"
echo "  4. cd $BASE_DIR/Humonics-dashboard && npm run dev"
