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
# home modules resolve mkOutOfStoreSymlink paths through ~/.dotfiles
ln -sfn "$DIR" ~/.dotfiles

echo "==> Step 3: personalize the configured username"
REAL_USER="$(whoami)"
FLAKE_USER="$(sed -nE 's/^[[:space:]]*user = "([^"]+)";.*/\1/p' "$DIR/flake.nix" | head -n1)"
if [ -z "$FLAKE_USER" ]; then
  echo "    Could not find user = \"...\" in flake.nix. Edit it yourself."
  exit 1
elif [ "$FLAKE_USER" != "$REAL_USER" ]; then
  echo "    flake.nix is configured for \"$FLAKE_USER\", but you are \"$REAL_USER\"."
  read -r -p "    Rewrite flake.nix user line to \"$REAL_USER\"? [y/N] " REPLY
  if [ "$REPLY" = "y" ] || [ "$REPLY" = "Y" ]; then
    sed -i '' -E "s/^([[:space:]]*user = \")[^\"]+(\";.*)/\1${REAL_USER}\2/" "$DIR/flake.nix"
    echo "    Updated. Review with: git diff flake.nix"
  else
    echo "    Skipped. Edit the user = line in flake.nix before continuing."
    exit 1
  fi
else
  echo "    flake.nix already matches \"$REAL_USER\""
fi

echo "==> Step 4: first darwin-rebuild switch (nix-darwin-26.05)"
NIX_BIN="$(command -v nix)"
# Host label is "mac" — must match flake.nix darwinConfigurations.mac and rebuild.sh
sudo "$NIX_BIN" run github:nix-darwin/nix-darwin/nix-darwin-26.05#darwin-rebuild -- \
  switch --flake ~/.dotfiles#mac

echo "==> Step 5: proto (Investtal toolchain)"
if ! command -v proto >/dev/null 2>&1; then
  echo "    installing proto..."
  curl -fsSL https://moonrepo.dev/install/proto.sh | bash
  export PATH="$HOME/.proto/bin:$PATH"
else
  echo "    proto already installed"
fi
echo "    installing tools from ~/.prototools (may take a while)..."
proto install || echo "    proto install reported issues — re-run manually later"

echo "==> Done."
echo "    Future changes:  cd ~/.dotfiles && ./rebuild.sh"
echo "    Open a new terminal so HM zsh + starship + proto PATH load cleanly."
