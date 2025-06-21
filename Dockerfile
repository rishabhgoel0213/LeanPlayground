# -------------------------------------------------------------
# Lean 4 + mathlib4 development image, personalised for Rishabh
# -------------------------------------------------------------
# Build:  docker build -t lean-dev .
# Shell:  docker run -it --rm -v "$PWD":/workspace lean-dev
#
# The repo’s contents are baked into /workspace so the image
# is self-contained.  At run-time we typically mount the repo
# again so edits are live (handled by dev.sh).
# -------------------------------------------------------------

FROM leanprover/lean4:stable

# ----- extra CLI goodies -----------------------------------------------------
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
        git ripgrep fzf \
 && rm -rf /var/lib/apt/lists/*

# ----- create non-root user ---------------------------------------------------
ARG USERNAME=lean
ARG UID=1000
RUN adduser --disabled-password --gecos "" --uid ${UID} ${USERNAME}

# ----- copy repo into the image ----------------------------------------------
COPY --chown=${USERNAME}:${USERNAME} . /workspace
WORKDIR /workspace

# ----- pull mathlib4 + its binary cache for speed -----------------------------
RUN lake update && lake exe cache get

# ----- switch to regular user & preseed git identity --------------------------
USER ${USERNAME}

# global git config (name & email) for this user
RUN git config --global user.name  "Rishabh Goel" \
 && git config --global user.email "rishabhgoel0213@gmail.com" \
 # make sure ~/.ssh exists for the incoming mount
 && mkdir -p ~/.ssh && chmod 700 ~/.ssh

CMD ["/bin/bash"]
