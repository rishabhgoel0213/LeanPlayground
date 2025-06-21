#!/usr/bin/env bash
# -----------------------------------------------------------------
# Build the image (cached) and start an interactive Lean shell
# with:
#   • repo mounted at /workspace
#   • host ~/.ssh mounted read-only so pushes work
# -----------------------------------------------------------------

set -euo pipefail

IMAGE="${IMAGE:-lean-dev}"
TAG="${TAG:-latest}"
SSH_DIR="${HOME}/.ssh"

echo "🔨  Building ${IMAGE}:${TAG} (will use cache if unchanged)…"
docker build -t "${IMAGE}:${TAG}" .

echo "🚀  Launching interactive Lean workspace…"
docker run --rm -it \
  -v "$(pwd)":/workspace \
  ${SSH_DIR:+-v "${SSH_DIR}":/home/lean/.ssh:ro} \
  --name lean-playground \
  "${IMAGE}:${TAG}" \
  bash
