#!/usr/bin/env bash
# Spin up a fully reproducible Lean container
# -----------------------------------------------------------
# 1. Builds the Docker image (if needed)
# 2. Starts an interactive shell with the repo mounted
#
# Usage:   ./dev.sh
# Extras:  IMAGE=lean-dev TAG=v1 ./dev.sh
# -----------------------------------------------------------

set -euo pipefail

IMAGE="${IMAGE:-lean-dev}"
TAG="${TAG:-latest}"

echo "🛠️  Building image ${IMAGE}:${TAG} (if necessary)…"
docker build -t "${IMAGE}:${TAG}" .

echo "🚀  Launching container. Ctrl-D or 'exit' to quit."
docker run --rm -it \
  -v "$(pwd)":/workspace \
  -u "$(id -u)":"$(id -g)" \
  --name lean-playground \
  "${IMAGE}:${TAG}" \
  bash
