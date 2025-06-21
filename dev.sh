#!/usr/bin/env bash
# ---------------------------------------------------------------------------
# One-shot script: build the image (if needed) and drop into an interactive
# container with:
#   • current repo mounted at /workspace
#   • host’s ~/.ssh mounted read-only at the container user’s ~/.ssh
#     → allows seamless git push/pull via your existing GitHub SSH keys
#
# Usage:     ./dev.sh
# Variables: IMAGE=lean-dev TAG=latest ./dev.sh
# ---------------------------------------------------------------------------

set -euo pipefail

IMAGE="${IMAGE:-lean-dev}"
TAG="${TAG:-latest}"
SSH_DIR="${HOME}/.ssh"

echo "🔨  Building ${IMAGE}:${TAG} (cached layers make this fast)…"
docker build -t "${IMAGE}:${TAG}" .

echo "🚀  Launching interactive Lean workspace…"
docker run --rm -it \
  -v "$(pwd)":/workspace \
  ${SSH_DIR:+-v "${SSH_DIR}":/home/lean/.ssh:ro} \
  --name lean-playground \
  "${IMAGE}:${TAG}" \
  bash
