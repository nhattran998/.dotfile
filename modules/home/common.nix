{
  config,
  pkgs,
  lib,
  username,
  ...
}:
let
  files = ../../files;
  homeDir = if pkgs.stdenv.isDarwin then "/Users/${username}" else "/home/${username}";
  teamHomeSeeds = [
    ".config/dcg/config.toml"
    ".config/ghostty/config"
    ".config/herdr/config.toml"
    ".config/hunk/config.toml"
    ".config/starship.toml"
    ".config/tmux/tmux.conf"
  ];
in
{
  home.username = username;
  home.homeDirectory = homeDir;
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;

  home.sessionVariables = {
    ME_INSTALL_PATH = lib.mkDefault "${config.home.homeDirectory}/Desktop/Me";
    EDITOR = lib.mkDefault "vim";
    GIT_PAGER = lib.mkDefault "delta";
    CODEGRAPH_QUERY_POOL_SIZE = lib.mkDefault "2";
    CODEGRAPH_TELEMETRY = lib.mkDefault "0";
    DO_NOT_TRACK = lib.mkDefault "1";
    MOON_TOOLCHAIN_FORCE_GLOBALS = "true";
    COREPACK_ENABLE = "0";
  };

  # Runtime source only. Do not read overlay env files in Nix (secrets must not enter the store).
  home.sessionVariablesExtra = builtins.readFile ../../scripts/source-overlays.sh;

  home.sessionPath = [
    "${config.home.homeDirectory}/.local/bin"
  ];

  home.packages = (import ../../packages/tools.nix { inherit pkgs; }).list;

  fonts.fontconfig.enable = true;

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "nhattran998";
        email = "nhattq.coding@gmail.com";
      };
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      core = {
        ignorecase = false;
        pager = "delta";
      };
      interactive.diffFilter = "delta --color-only";
      delta = {
        navigate = true;
        line-numbers = true;
      };
      alias = {
        co = "checkout";
        br = "branch";
        ci = "commit";
        st = "status";
      };
    };
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history = {
      append = true;
      size = 50000;
      save = 50000;
      ignoreDups = true;
      ignoreSpace = true;
      share = true;
    };

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "git-auto-fetch"
      ];
    };

    shellAliases = {
      ".." = "cd ..";
      "..." = "cd ../..";
      ll = "eza -la --git";
      ls = "eza";
      tree = "eza -T";
      cat = "bat";
      gpo = "git pull origin";
      gpod = "git pull origin develop";
      grf = "git checkout -f";
      guf = "git clean -fd";
      gulc = "git reset --soft HEAD~1";
      gcmam = "git commit --amend -m";
      zshconfig = "$EDITOR ~/.zshrc";
      dots = "cd ~/.dotfiles";
      rebuild = "~/.dotfiles/rebuild.sh";
    };

    initContent = lib.mkOrder 1000 ''
      GIT_AUTO_FETCH_INTERVAL=30

      bindkey '^f' autosuggest-accept

      execr() {
        find . -maxdepth 1 -type d \( ! -name . \) -exec bash -c "cd '{}' && $1" \;
      }

      autoload -Uz add-zsh-hook
      _me_auto_pull_main() {
        local branch git_dir upstream

        branch=$(command git symbolic-ref --quiet --short HEAD 2>/dev/null) || return 0
        [[ "$branch" == main ]] || return 0
        git_dir=$(command git rev-parse --git-dir 2>/dev/null) || return 0
        [[ -f "$git_dir/NO_AUTO_FETCH" ]] && return 0

        upstream=$(command git rev-parse --abbrev-ref --symbolic-full-name '@{upstream}' 2>/dev/null) || return 0
        [[ "$upstream" == origin/main ]] || return 0

        command git merge-base --is-ancestor HEAD origin/main 2>/dev/null || return 0
        command git merge-base --is-ancestor origin/main HEAD 2>/dev/null && return 0
        command git diff --quiet -- || return 0
        command git diff --cached --quiet -- || return 0

        if command git merge --ff-only --quiet origin/main; then
          print -- "Auto-updated main from origin/main."
        fi
      }
      add-zsh-hook precmd _me_auto_pull_main

      if [[ ''${TERM:-} != dumb ]] && command -v starship >/dev/null 2>&1; then
        eval "$(starship init zsh)"
      fi

      if command -v zoxide >/dev/null 2>&1; then
        eval "$(zoxide init zsh)"
      fi
    '';
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  home.activation.seedTeamDotfiles = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    _me_seed() {
      dest="$HOME/$1"
      src="$2"
      if [ -e "$dest" ] || [ -L "$dest" ]; then
        return 0
      fi
      $DRY_RUN_CMD mkdir -p "$(dirname "$dest")"
      $DRY_RUN_CMD cp "$src" "$dest"
      $DRY_RUN_CMD chmod u+w "$dest"
    }
    ${lib.concatMapStrings (
      rel:
      let
        src = files + "/${rel}";
      in
      ''
        _me_seed ${lib.escapeShellArg rel} ${lib.escapeShellArg (toString src)}
      ''
    ) teamHomeSeeds}
    unset -f _me_seed
  '';
}
