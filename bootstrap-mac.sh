#!/usr/bin/env bash
# Fresh (or existing) Mac → nix-darwin config applied.
# Run once. After that use ./rebuild.sh for changes.
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"

echo "==> Step 1: Determinate Nix"
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

echo "==> Step 3: first darwin-rebuild switch (nix-darwin-26.05, impure USER)"
NIX_BIN="$(command -v nix)"
sudo env HOME=/var/root USER="$USER" SUDO_USER="$USER" PATH="$PATH" \
  "$NIX_BIN" run --impure nix-darwin/nix-darwin-26.05 -- \
  switch --impure --flake ~/.dotfiles#mac

echo "==> Done."
echo "    Future changes:  cd ~/.dotfiles && ./rebuild.sh"
echo "    Open a new terminal so HM zsh + starship PATH load cleanly."
