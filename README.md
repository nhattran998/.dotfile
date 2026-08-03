# .dotfile — multi-host Nix setup

Declarative, reproducible environment for:

| Host | How it is managed |
| --- | --- |
| **MacBook M4** (`aarch64-darwin`) | [nix-darwin](https://github.com/nix-darwin/nix-darwin) + [home-manager](https://github.com/nix-community/home-manager) + [nix-homebrew](https://github.com/zhaofengli/nix-homebrew) |
| **Ubuntu server** | home-manager only (Ubuntu stays the OS) |

Inspired by [kunchenguid/dotfiles](https://github.com/kunchenguid/dotfiles), adapted for **Ghostty**, **herdr**, and the **Investtal proto toolchain** (`9cc`, `atlassian`, `gh`, `gitleaks`, …).

We intentionally **do not** manage pi / wezterm / nvim like that reference.

## Why Nix + proto

- **Nix** owns the shell, CLI utilities, macOS defaults, and Homebrew *declarations* → reproducible system shape.
- **proto** owns language runtimes and Investtal-built tools (audited plugins from [investtal-toolchain/proto](https://github.com/investtal/investtal-toolchain/tree/main/proto)) → same pins on Mac and server.

## Layout

```text
flake.nix                 # darwinConfigurations.mac + homeConfigurations
bootstrap-mac.sh          # first-time Mac apply
bootstrap-linux.sh        # first-time Ubuntu apply
rebuild.sh                # daily: re-apply after edits
modules/
  darwin/                 # system defaults + homebrew (cleanup = none)
  home/                   # common / mac / linux / proto
hosts/
  mac/                    # Mac host glue
  server/                 # thin server overrides
home/
  .config/ghostty/        # edit live via symlink
  .config/herdr/          # config.toml only (not runtime socks/logs)
  .prototools             # pinned investtal-toolchain plugin URLs
scripts/                  # optional utility scripts
archive/                  # old imperative configs (kept for reference)
docs/                     # notes (e.g. fedora-server-selfhost)
```

**Symlink model:** `bootstrap` / `rebuild` always link this repo to `~/.dotfiles`. home-manager uses `mkOutOfStoreSymlink`, so editing `home/.config/...` edits the live file. Run `./rebuild.sh` only when you change packages, system options, or module structure.

## Prerequisites

- **Mac:** Apple Silicon (M4). Username defaults to `harrytran998` in `flake.nix`.
- **Server:** Ubuntu with a normal user account. Set `serverUser` and `serverSystem` in `flake.nix` (`x86_64-linux` or `aarch64-linux`).

## Fresh Mac

```bash
git clone https://github.com/nhattran998/.dotfile.git
cd .dotfile
./bootstrap-mac.sh
```

What it does: ensure Determinate Nix → symlink `~/.dotfiles` → first `darwin-rebuild switch` → install proto tools from `~/.prototools`.

### Validate without applying

```bash
nix flake check --no-build
nix build .#darwinConfigurations.mac.system --dry-run
```

## Fresh Ubuntu server

```bash
git clone https://github.com/nhattran998/.dotfile.git ~/.dotfiles
cd ~/.dotfiles
# edit flake.nix: serverUser + serverSystem if needed
./bootstrap-linux.sh
```

## Daily use

```bash
cd ~/.dotfiles
# edit modules or home/* …
./rebuild.sh        # auto: mac on Darwin, server on Linux
./rebuild.sh mac
./rebuild.sh server
```

## Homebrew note (Mac)

`modules/darwin/homebrew.nix` sets `onActivation.cleanup = "none"`. Declared packages (`herdr`, `ghostty`) are ensured; **nothing undeclared is uninstalled**. Add more `brews` / `casks` when you want them managed.

## Proto / Investtal tools

Managed file: `home/.prototools` → `~/.prototools`.

Plugins are pinned to **commit SHAs** on `investtal/investtal-toolchain` (not floating branches, not local `file://` paths) so Mac and server resolve the same definitions.

```bash
proto install          # install/update tools listed in ~/.prototools
proto outdated         # see bumps
```

After changing plugin SHAs in `home/.prototools`, run `proto install` again (no flake rebuild required).

## Shell

- **zsh** via home-manager (autosuggestions + syntax highlighting)
- **starship** prompt
- no oh-my-zsh / powerlevel10k (old configs live under `archive/shell/`)

## What was archived

Legacy flat configs moved under `archive/` (alacritty, windows-terminal, tmux, p10k, old zshrc, linux-setup.sh, etc.). Nothing was hard-deleted in the first migration.

## Make it yours

| Knob | Where |
| --- | --- |
| Mac username | `user = "..."` in `flake.nix` |
| Server username | `serverUser = "..."` in `flake.nix` |
| Server arch | `serverSystem = "x86_64-linux"` or `"aarch64-linux"` |
| Host label `mac` / `server` | `flake.nix` + `rebuild.sh` / bootstrap scripts |
| Brew packages | `modules/darwin/homebrew.nix` |
| Shared CLI packages | `modules/home/common.nix` |
| Toolchain versions | `home/.prototools` |

## License

Personal config — use / fork freely.
