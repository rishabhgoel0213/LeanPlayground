# ───────────────────────────────────────────────────────────────
# Lean 4 + mathlib4 playground image — tuned for Rishabh Goel
# Build:  docker build -t lean-dev .
# Run :  ./dev.sh          (see script below)
# ───────────────────────────────────────────────────────────────
FROM debian:bookworm-slim

# ── 1. system packages ─────────────────────────────────────────
# bash            → real interactive shell
# curl, ca-cert   → fetch elan installer safely
# git, ripgrep, fzf → everyday dev niceties
# build-essential → g++, make … needed by mathlib C parts
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
        bash curl ca-certificates git ripgrep fzf build-essential \
 && rm -rf /var/lib/apt/lists/*

# ── 2. non-root user (UID 1000 so mounts map nicely) ───────────
ARG USERNAME=lean
ARG UID=1000
RUN useradd -m -u "${UID}" -s /bin/bash "${USERNAME}"

# ── 3. install Lean with elan (non-interactive) ────────────────
USER ${USERNAME}
WORKDIR /home/${USERNAME}

#   Download & run the installer non-interactively (-y)
RUN curl -sSf https://raw.githubusercontent.com/leanprover/elan/master/elan-init.sh \
    | bash -s -- -y
#   Select the current Lean 4 stable toolchain
RUN ~/.elan/bin/elan default leanprover/lean4:stable

ENV PATH="/home/${USERNAME}/.elan/bin:${PATH}"

# ── 4. prepare Git identity & SSH mount point ──────────────────
RUN git config --global user.name  "Rishabh Goel" \
 && git config --global user.email "rishabhgoel0213@gmail.com" \
 && mkdir -p ~/.ssh && chmod 700 ~/.ssh

# ── 5. copy repo contents into image (so it's runnable even
#       without a bind-mount)  ──────────────────────────────────
COPY --chown=${USERNAME}:${USERNAME} . /workspace
WORKDIR /workspace

CMD ["/bin/bash"]
