{
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./common.nix
    ./proto.nix
  ];

  # username / homeDirectory set by flake homeConfigurations."*@server" wrapper
  # (or override in hosts/server if you add one).

  home.packages = with pkgs; [
    # server-friendly extras (no GUI)
    tmux # fallback if herdr is not installed yet
    rsync
  ];

  # No Ghostty on the server. herdr config still symlinked via common.nix.
  # Install herdr on Linux via its upstream release / brew (if available), then
  # rebuild so the config symlink is in place.
}
