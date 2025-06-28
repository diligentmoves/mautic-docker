#!/bin/bash
set -e

REPO_USER="diligentmoves"
REPO_NAME="mautic-docker"
BRANCH="main"
TARGET_DIR="mautic-docker"

echo "🧹 Cleaning up old containers (if any)..."
docker rm -f mautic traefik mautic-db 2>/dev/null || true

echo "🧼 Removing old folders..."
rm -rf ~/mautic-n8n-stack ~/mautic-docker-main ~/mautic-docker

echo "📦 Downloading project from GitHub..."
wget -q https://github.com/$REPO_USER/$REPO_NAME/archive/refs/heads/$BRANCH.zip -O mautic.zip

echo "📂 Unzipping..."
unzip -q mautic.zip
mv "$REPO_NAME-$BRANCH" "$TARGET_DIR"
cd "$TARGET_DIR"

echo "🛠️  Installing Docker (if needed)..."
if ! command -v docker &> /dev/null; then
  curl -fsSL https://get.docker.com -o get-docker.sh && sh get-docker.sh
  apt install -y docker-compose-plugin
fi

echo "📝 Please edit your .env file before continuing."
sleep 1
nano .env

echo "🚀 Launching Mautic stack..."
docker compose --env-file .env up -d

echo "🧹 Cleaning up..."
cd ..
rm -f mautic.zip

echo "✅ Done! Visit your Mautic site to complete setup."
