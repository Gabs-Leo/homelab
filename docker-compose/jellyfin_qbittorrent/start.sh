#!/bin/bash

# Check for modern Docker Compose V2 (as a docker plugin)
if docker compose version >/dev/null 2>&1; then
    echo "✅ Docker Compose (V2 Plugin) is installed."
    echo "Version: $(docker compose version)"

# Check for legacy Docker Compose V1 (standalone binary)
elif command -v docker-compose >/dev/null 2>&1; then
    echo "⚠️ Legacy Docker Compose (V1 Standalone) is installed."
    echo "Version: $(docker-compose --version)"

# Neither version is found
else
    echo "❌ Docker Compose is NOT installed."
    exit 1
fi

docker-compose up -d

while true; do
    STATUS=$(docker inspect -f '{{.State.Status}}' "qbittorrent" 2>/dev/null)

    if [ "$STATUS" = "running" ]; then
        echo "Success! Container 'qbittorrent' is now running."
        echo "=========================================================="

        break
    elif [ -z "$STATUS" ]; then
        echo "Status: Container does not exist yet. Retrying in 2s..."
    else
        echo "Status: Current state is '${STATUS}'. Waiting for 'running' state... Retrying in 2s..."
    fi

    sleep 2
done
sleep 5
docker logs qbittorrent