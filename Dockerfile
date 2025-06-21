# -------------------------------------------------------------
# Lean 4 + mathlib4 dev image, personalised for Rishabh Goel
# -------------------------------------------------------------
# Build:  docker build -t lean-dev .
# Shell:  docker run -it --rm -v "$PWD":/workspace lean-dev
# -------------------------------------------------------------

FROM leanprovercommunity/lean4:latest

# ----- extras you’ll probably want inside the container -----
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
        git ripgrep fzf \
 && rm -rf /var/lib/apt/lists/*

# ----- non-root Lean user (UID 1000) -------------------------
ARG USERNAME=lean
ARG UID=1000
RUN adduser --disabled-password --gecos "" --uid ${UID} ${USERNAME}

# ----- copy repo into the image ------------------------------
COPY --chown=${USERNAME}:${USERNAME} . /workspace
WORKDIR /workspace

# ----- pre-fetch mathlib4 cache for fast first builds --------
RUN lake update && lake exe cache get

# ----- configure Git identity & ensure an ~/.ssh directory ---
USER ${USERNAME}
RUN git config --global user.name  "Rishabh Goel"  \
 && git config --global user.email "rishabhgoel0213@gmail.com" \
 && mkdir -p ~/.ssh && chmod 700 ~/.ssh

CMD ["/bin/bash"]
