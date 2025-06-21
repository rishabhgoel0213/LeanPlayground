#!/usr/bin/env bash
# ------------------------------------------------------------------
# Build the Lean image (x86-64 by default) and drop into it.
# ------------------------------------------------------------------

set -euo pipefail

IMAGE="${IMAGE:-lean-dev}"
TAG="${TAG:-latest}"
PLATFORM="${PLATFORM:-linux/amd64}"     # keep if you ever need QEMU
SSH_DIR="${HOME}/.ssh"

echo "🔨  Building ${IMAGE}:${TAG} for ${PLATFORM}…"
docker build --platform "${PLATFORM}" -t "${IMAGE}:${TAG}" .

echo "🚀  Launching interactive Lean workspace…"
docker run --platform "${PLATFORM}" --rm -it \
  -v "$(pwd)":/workspace \
  ${SSH_DIR:+-v "${SSH_DIR}":/home/lean/.ssh:ro} \
  --name lean-playground \
  "${IMAGE}:${TAG}"
