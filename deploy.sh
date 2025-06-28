#!/bin/bash
set -e

REPO_USER="diligentmoves"
REPO_NAME="mautic-docker"
BRANCH="main"

echo "📦 Downloading project from GitHub..."
wget -q https://github.com/$REPO_USER/$REPO_NAME/archive/refs/heads/$BRANCH.zip -O mautic.zip

echo "📂 Unzipping..."
unzip -q mautic.zip
cd "$REPO_NAME-$BRANCH"

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
rm -rf mautic.zip "$REPO_NAME-$BRANCH"

echo "✅ Done! Visit your Mautic site to complete setup."
