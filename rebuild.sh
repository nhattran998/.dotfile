#!/usr/bin/env bash
# Re-apply the flake after edits. Usage:
#   ./rebuild.sh           # auto-detect Darwin → mac, else server
#   ./rebuild.sh mac
#   ./rebuild.sh server
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
ln -sfn "$DIR" ~/.dotfiles

TARGET="${1:-auto}"

if [ "$TARGET" = "auto" ]; then
  case "$(uname -s)" in
    Darwin) TARGET=mac ;;
    Linux)  TARGET=server ;;
    *)
      echo "Unknown OS; pass mac or server explicitly."
      exit 1
      ;;
  esac
fi

case "$TARGET" in
  mac)
    echo "==> darwin-rebuild switch --flake ~/.dotfiles#mac"
    if command -v darwin-rebuild >/dev/null 2>&1; then
      exec sudo darwin-rebuild switch --flake ~/.dotfiles#mac
    else
      NIX_BIN="$(command -v nix)"
      exec sudo "$NIX_BIN" run github:nix-darwin/nix-darwin/nix-darwin-26.05#darwin-rebuild -- \
        switch --flake ~/.dotfiles#mac
    fi
    ;;
  server)
    USER_NAME="$(whoami)"
    echo "==> home-manager switch --flake ~/.dotfiles#${USER_NAME}@server"
    if command -v home-manager >/dev/null 2>&1; then
      exec home-manager switch --flake "${DIR}#${USER_NAME}@server"
    else
      exec nix run home-manager/release-26.05 -- switch --flake "${DIR}#${USER_NAME}@server"
    fi
    ;;
  *)
    echo "Usage: $0 [mac|server|auto]"
    exit 1
    ;;
esac
