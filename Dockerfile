# -------------------------------------------------------------
# Lean 4 + mathlib4 dev image, personalised for Rishabh Goel
# -------------------------------------------------------------
FROM leanprovercommunity/lean4:latest

# ── Become root so apt can write to /var/lib/apt/lists ─────────
USER root

# ----- CLI extras -------------------------------------------------------------
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
        git ripgrep fzf \
 && rm -rf /var/lib/apt/lists/*

# ----- make sure the 'lean' user exists (UID 1000) --------------
ARG USERNAME=lean
ARG UID=1000
RUN id -u "$USERNAME" 2>/dev/null || \
    adduser --disabled-password --uid "$UID" --gecos "" "$USERNAME"

# ----- copy repo into the image ----------------------------------------------
COPY --chown=${USERNAME}:${USERNAME} . /workspace
WORKDIR /workspace

# ----- pre-fetch mathlib cache for faster first build ------------
RUN lake update && lake exe cache get

# ----- configure git & prepare ~/.ssh mount point ----------------
USER ${USERNAME}
RUN git config --global user.name  "Rishabh Goel" \
 && git config --global user.email "rishabhgoel0213@gmail.com" \
 && mkdir -p ~/.ssh && chmod 700 ~/.ssh

CMD ["/bin/bash"]
