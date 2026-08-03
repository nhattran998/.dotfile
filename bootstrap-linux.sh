#!/usr/bin/env bash
# Ubuntu (or other Linux) → home-manager only. Does not install NixOS.
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
HOST_LABEL="${1:-server}"

echo "==> Step 1: Nix"
if command -v nix >/dev/null 2>&1; then
  echo "    nix already installed, skipping"
else
  curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix \
    | sh -s -- install --no-confirm
  # shellcheck disable=SC1091
  . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
fi

echo "==> Step 2: symlink this repo to ~/.dotfiles"
ln -sfn "$DIR" ~/.dotfiles

echo "==> Step 3: enable flakes (if not already)"
mkdir -p ~/.config/nix
if ! grep -q 'experimental-features' ~/.config/nix/nix.conf 2>/dev/null; then
  echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
fi

REAL_USER="$(whoami)"
FLAKE_TARGET="${REAL_USER}@${HOST_LABEL}"
echo "==> Step 4: home-manager switch --flake ~/.dotfiles#${FLAKE_TARGET}"
echo "    (serverUser in flake.nix must match \"$REAL_USER\"; host label is \"${HOST_LABEL}\")"

nix run home-manager/release-26.05 -- switch --flake "${DIR}#${FLAKE_TARGET}"

echo "==> Step 5: proto (Investtal toolchain)"
if ! command -v proto >/dev/null 2>&1; then
  curl -fsSL https://moonrepo.dev/install/proto.sh | bash
  export PATH="$HOME/.proto/bin:$PATH"
fi
proto install || echo "    proto install reported issues — re-run manually later"

echo "==> Done."
echo "    Future changes:  cd ~/.dotfiles && ./rebuild.sh server"
echo "    Install herdr from upstream releases if you want the same multiplexer on the server."
