# Lean 4 + mathlib4 dev image for Rishabh Goel
FROM leanprovercommunity/lean4:latest

# ── become root so apt works ──────────────────────────────────
USER root
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
        bash git ripgrep fzf
RUN rm -rf /var/lib/apt/lists/*

# ── ensure “lean” user (UID 1000) exists ─────────────────────
ARG USERNAME=lean
ARG UID=1000
RUN id -u "$USERNAME" 2>/dev/null || \
    adduser --disabled-password --uid "$UID" --gecos "" "$USERNAME"

# ── copy repo into image ──────────────────────────────────────
COPY --chown=${USERNAME}:${USERNAME} . /workspace
WORKDIR /workspace

# ── switch to lean user, install toolchain, git identity ─────
USER ${USERNAME}
RUN elan default leanprover/lean4:stable
RUN git config --global user.name  "Rishabh Goel" \
 && git config --global user.email "rishabhgoel0213@gmail.com" \
 && mkdir -p ~/.ssh && chmod 700 ~/.ssh

# Start an interactive shell by default
CMD ["/bin/bash"]
