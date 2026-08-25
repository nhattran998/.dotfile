# .dotfile — personal Nix developer profile

Declarative environment for:

| Host | How it is managed |
| --- | --- |
| **MacBook M4** (`aarch64-darwin`) | [nix-darwin](https://github.com/nix-darwin/nix-darwin) + [home-manager](https://github.com/nix-community/home-manager) + [nix-homebrew](https://github.com/zhaofengli/nix-homebrew) |
| **Linux** | home-manager only (Ubuntu / WSL2 / Omarchy) |

Apply is **impure** so `USER` / `HOME` resolve.

## Layout

```text
flake.nix                 # darwinConfigurations.mac + homeConfigurations.me-*
bootstrap-mac.sh          # first-time Mac apply
bootstrap-linux.sh        # first-time Linux apply
rebuild.sh                # daily: re-apply after edits
packages/                 # pinned CLI tools (moon, bun, herdr, …)
modules/
  darwin/                 # Determinate Nix + Homebrew (cleanup = none)
  home/                   # common / linux / omarchy
hosts/mac/                # Mac host glue
files/                    # seed copies into $HOME when missing
scripts/source-overlays.sh
```

## Flake attrs

| Host | Flake attr |
| --- | --- |
| macOS | `.#mac` |
| Ubuntu / WSL2 x86_64 | `.#me-linux` |
| Ubuntu / WSL2 aarch64 | `.#me-linux-aarch64` |
| Omarchy x86_64 | `.#me-omarchy` |
| Omarchy aarch64 | `.#me-omarchy-aarch64` |

`--impure` is required so the flake can read `SUDO_USER` / `USER` for your home path.

## Env overlays

Login shells source (later wins):

1. `$HOME/local.env`
2. `$HOME/.config/local.env`
3. `$HOME/.config/me/local.env` (non-empty keys only)

`ME_INSTALL_PATH` defaults to `~/Desktop/Me`.
`ME_KEEP_BASH=1` keeps Bash on Linux instead of exec'ing Zsh.

Secrets stay out of the Nix store.

## Fresh Mac

```bash
cd ~/.dotfiles
./bootstrap-mac.sh
```

Later:

```bash
sudo env HOME=/var/root USER="$USER" SUDO_USER="$USER" PATH="$PATH" \
  darwin-rebuild switch --impure --flake ~/.dotfiles#mac
```

## Fresh Linux

```bash
cd ~/.dotfiles
./bootstrap-linux.sh
```

Later:

```bash
home-manager switch -b before-hm --impure --flake ~/.dotfiles#me-linux
```

## Daily use

```bash
cd ~/.dotfiles
./rebuild.sh        # mac on Darwin, me-linux on Linux
./rebuild.sh mac
./rebuild.sh linux
```

## Homebrew note (Mac)

`modules/darwin/homebrew.nix` sets `onActivation.cleanup = "none"`. Ghostty is a cask. Undeclared brew packages stay installed.

## Shell

- zsh via home-manager (autosuggestions + syntax highlighting + oh-my-zsh git)
- starship + zoxide
- auto fast-forward of a clean local `main` that tracks `origin/main`

## License

Personal config — use / fork freely.
