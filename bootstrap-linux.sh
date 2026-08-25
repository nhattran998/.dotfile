#!/usr/bin/env bash
# Ubuntu (or other Linux) → home-manager only. Does not install NixOS.
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"

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

ARCH="$(uname -m)"
if [ "$ARCH" = "aarch64" ] || [ "$ARCH" = "arm64" ]; then
  ATTR=me-linux-aarch64
else
  ATTR=me-linux
fi

echo "==> Step 4: home-manager switch --impure --flake ~/.dotfiles#${ATTR}"
nix run home-manager/release-26.05 -- switch -b before-hm --impure --flake "${DIR}#${ATTR}"

echo "==> Done."
echo "    Future changes:  cd ~/.dotfiles && ./rebuild.sh linux"
