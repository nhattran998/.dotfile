{
  config,
  pkgs,
  lib,
  ...
}:
let
  # Repo is always linked to ~/.dotfiles by bootstrap/rebuild scripts.
  # mkOutOfStoreSymlink keeps live configs editable without a rebuild.
  dotfiles = "${config.home.homeDirectory}/.dotfiles";
in
{
  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    # everyday CLI
    ripgrep
    fd
    fzf
    jq
    yq-go
    eza
    bat
    tree
    curl
    wget
    lazygit
    delta
    direnv
    # process / net helpers (safe on both platforms)
    htop
    bottom
    vim
  ];

  home.sessionVariables = {
    # No nvim in this flake — override in a host module if you add an editor.
    EDITOR = "vim";
    GIT_PAGER = "delta";
  };

  fonts.fontconfig.enable = true;

  programs.home-manager.enable = true;

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
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    history = {
      size = 50000;
      save = 50000;
      share = true;
    };
    shellAliases = {
      ".." = "cd ..";
      "..." = "cd ../..";
      ll = "eza -la --git";
      ls = "eza";
      tree = "eza -T";
      cat = "bat";
      # git helpers (from previous .zshrc)
      gpo = "git pull origin";
      gpod = "git pull origin develop";
      grf = "git checkout -f";
      guf = "git clean -fd";
      gulc = "git reset --soft HEAD~1";
      gcmam = "git commit --amend -m";
      # config shortcuts
      zshconfig = "$EDITOR ~/.zshrc";
      dots = "cd ~/.dotfiles";
      rebuild = "~/.dotfiles/rebuild.sh";
    };
    initContent = ''
      # Accept autosuggestion with Ctrl-f
      bindkey '^f' autosuggest-accept

      # Run a command in every immediate subdirectory
      execr() {
        find . -maxdepth 1 -type d \( ! -name . \) -exec bash -c "cd '{}' && $1" \;
      }
    '';
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      format = "$directory$git_branch$git_status$cmd_duration$line_break$character";
      character = {
        success_symbol = "[❯](purple)";
        error_symbol = "[❯](red)";
      };
      cmd_duration = {
        format = "[$duration]($style) ";
        min_time = 2000;
      };
      directory = {
        truncation_length = 3;
        truncate_to_repo = true;
      };
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # Edit-in-place configs (real files live under ~/.dotfiles/home/...).
  home.file.".config/herdr/config.toml".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/herdr/config.toml";

  home.file.".prototools".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.prototools";
}
