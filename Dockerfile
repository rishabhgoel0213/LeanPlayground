# Lean 4 + mathlib4 dev image for Rishabh Goel
FROM leanprovercommunity/lean4:latest

# ── become root so apt works ──────────────────────────────────
USER root
RUN apt-get update \
 && apt-get install -y --no-install-recommends git ripgrep fzf \
 && rm -rf /var/lib/apt/lists/*

# ── ensure “lean” user (UID 1000) exists ─────────────────────
ARG USERNAME=lean
ARG UID=1000
RUN id -u "$USERNAME" 2>/dev/null || \
    adduser --disabled-password --uid "$UID" --gecos "" "$USERNAME"

# ── copy repo into image ──────────────────────────────────────
COPY --chown=${USERNAME}:${USERNAME} . /workspace
WORKDIR /workspace

# ── lean user: install stable toolchain & set Git identity ───
USER ${USERNAME}

# ❶  Install / select current Lean 4 stable toolchain
RUN elan default leanprover/lean4:stable

# ❷  Pre-create ~/.ssh (mount point) and Git config
RUN git config --global user.name  "Rishabh Goel" \
 && git config --global user.email "rishabhgoel0213@gmail.com" \
 && mkdir -p ~/.ssh && chmod 700 ~/.ssh

CMD ["/bin/bash"]
