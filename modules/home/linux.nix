# Generic Linux Home Manager (Ubuntu, WSL2, and as a base for Omarchy).
{
  pkgs,
  lib,
  ...
}:
{
  assertions = [
    {
      assertion = pkgs.stdenv.isLinux;
      message = "modules/home/linux.nix is for Linux Home Manager hosts only";
    }
  ];

  targets.genericLinux.enable = true;

  home.packages = with pkgs; [
    tmux
    rsync
  ];

  # Keep Bash as the system login shell, then hand interactive sessions to
  # the Nix-managed Zsh without requiring chsh.
  programs.bash = {
    enable = true;
    initExtra = lib.mkAfter ''
      # ME_KEEP_BASH=1 bash provides an explicit Bash escape hatch.
      if [[ -z "''${ME_KEEP_BASH:-}" ]]; then
        exec ${lib.getExe pkgs.zsh} -l
      fi
    '';
  };
}
