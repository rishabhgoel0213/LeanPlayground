# Lean 4 + mathlib4 dev image for Rishabh Goel
FROM leanprovercommunity/lean4:latest

# ── root for apt ───────────────────────────────────────────────
USER root
RUN apt-get update \
 && apt-get install -y --no-install-recommends git ripgrep fzf \
 && rm -rf /var/lib/apt/lists/*

# ── make sure the “lean” user exists (UID 1000) ────────────────
ARG USERNAME=lean
ARG UID=1000
RUN id -u "$USERNAME" 2>/dev/null || \
    adduser --disabled-password --uid "$UID" --gecos "" "$USERNAME"

# ── copy repo into the image ───────────────────────────────────
COPY --chown=${USERNAME}:${USERNAME} . /workspace
WORKDIR /workspace

# ── switch to regular user, set Lean toolchain ────────────────
USER ${USERNAME}

# ❶ Pick a toolchain (installs it if missing)
RUN elan self update -y && \
    elan default leanprover/lean4:stable

# ❷ (Optional but handy) prime mathlib cache
RUN lake init _cache math      && \
    cd _cache                  && \
    lake exe cache get         && \
    cd .. && rm -rf _cache

# ❸ Git identity + SSH mount point
RUN git config --global user.name  "Rishabh Goel"        && \
    git config --global user.email "rishabhgoel0213@gmail.com" && \
    mkdir -p ~/.ssh && chmod 700 ~/.ssh

CMD ["/bin/bash"]
