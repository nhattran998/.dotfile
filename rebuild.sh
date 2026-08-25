#!/usr/bin/env bash
# Re-apply the flake after edits. Usage:
#   ./rebuild.sh           # auto-detect Darwin → mac, else me-linux
#   ./rebuild.sh mac
#   ./rebuild.sh linux
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
ln -sfn "$DIR" ~/.dotfiles

TARGET="${1:-auto}"

if [ "$TARGET" = "auto" ]; then
  case "$(uname -s)" in
    Darwin) TARGET=mac ;;
    Linux)  TARGET=linux ;;
    *)
      echo "Unknown OS; pass mac or linux explicitly."
      exit 1
      ;;
  esac
fi

case "$TARGET" in
  mac)
    echo "==> darwin-rebuild switch --impure --flake ~/.dotfiles#mac"
    if command -v darwin-rebuild >/dev/null 2>&1; then
      exec sudo env HOME=/var/root USER="$USER" SUDO_USER="$USER" PATH="$PATH" \
        darwin-rebuild switch --impure --flake ~/.dotfiles#mac
    else
      NIX_BIN="$(command -v nix)"
      exec sudo env HOME=/var/root USER="$USER" SUDO_USER="$USER" PATH="$PATH" \
        "$NIX_BIN" run --impure nix-darwin/nix-darwin-26.05 -- \
        switch --impure --flake ~/.dotfiles#mac
    fi
    ;;
  linux)
    ARCH="$(uname -m)"
    if [ "$ARCH" = "aarch64" ] || [ "$ARCH" = "arm64" ]; then
      ATTR=me-linux-aarch64
    else
      ATTR=me-linux
    fi
    echo "==> home-manager switch --impure --flake ~/.dotfiles#${ATTR}"
    if command -v home-manager >/dev/null 2>&1; then
      exec home-manager switch -b before-hm --impure --flake "${DIR}#${ATTR}"
    else
      exec nix run home-manager/release-26.05 -- switch -b before-hm --impure --flake "${DIR}#${ATTR}"
    fi
    ;;
  *)
    echo "Usage: $0 [mac|linux|auto]"
    exit 1
    ;;
esac
