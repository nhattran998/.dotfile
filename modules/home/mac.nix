{
  config,
  pkgs,
  user,
  ...
}:
let
  dotfiles = "${config.home.homeDirectory}/.dotfiles";
in
{
  imports = [
    ./common.nix
    ./proto.nix
  ];

  home.username = user;
  home.homeDirectory = "/Users/${user}";

  home.packages = with pkgs; [
    # fonts used by Ghostty
    nerd-fonts.fira-code
  ];

  # Ghostty config — brew installs the app; we own the config file.
  home.file.".config/ghostty".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/ghostty";
}
