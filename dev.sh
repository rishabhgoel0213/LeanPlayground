#!/usr/bin/env bash
# Build (cached) and open an interactive Lean shell
# --------------------------------------------------------------

set -euo pipefail

IMAGE="${IMAGE:-lean-dev}"
TAG="${TAG:-latest}"
SSH_DIR="${HOME}/.ssh"

echo "🔨  Building ${IMAGE}:${TAG} …"
docker build -t "${IMAGE}:${TAG}" .

echo "🚀  Dropping you into the container …"
docker run --rm -it \
  -v "$(pwd)":/workspace \
  ${SSH_DIR:+-v "${SSH_DIR}":/home/lean/.ssh:ro} \
  --name lean-playground \
  "${IMAGE}:${TAG}"
