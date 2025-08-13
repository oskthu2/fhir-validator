# Preload all local IG .tgz files into the shared package cache
docker compose build
docker compose run --rm prewarm
