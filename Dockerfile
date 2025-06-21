# ----------------------------
# Lean 4 + mathlib4 dev image
# ----------------------------
# Build with:  docker build -t lean-dev .
# Run  with :  docker run -it --rm -v "$PWD":/workspace lean-dev
#
# Everything in the repo is baked into /workspace at image-build time,
# then you normally re-mount the repo so edits are live.

FROM leanprover/lean4:stable

# ----- extras you’ll probably want inside the container -----
# • git        – version-control from inside the container
# • ripgrep    – lightning-fast searching through proofs
# • fzf        – fuzzy finder (great with rg + your shell)
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
        git ripgrep fzf \
 && rm -rf /var/lib/apt/lists/*

# ----- non-root user so mounted files aren’t owned by root -----
ARG USERNAME=lean
ARG UID=1000
RUN adduser --disabled-password --gecos "" --uid $UID $USERNAME

# ----- copy the repo itself into the image -----
# • This guarantees a working project even if you *don’t* mount.
# • We set owner now so either root or USERNAME can rebuild Lake targets.
COPY --chown=${USERNAME}:${USERNAME} . /workspace

WORKDIR /workspace

# ----- pull mathlib4 & its compiled cache for speed -----
RUN lake update \
 && lake exe cache get

USER $USERNAME
CMD ["/bin/bash"]
