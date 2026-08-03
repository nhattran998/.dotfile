{ user, ... }:
{
  # Determinate Nix owns the daemon — do not let nix-darwin fight it.
  nix.enable = false;

  nixpkgs.config.allowUnfree = true;
  nixpkgs.hostPlatform = "aarch64-darwin";

  system.primaryUser = user;
  users.users.${user} = {
    home = "/Users/${user}";
  };

  # Bump only when nix-darwin docs say to.
  system.stateVersion = 6;

  # Conservative macOS defaults — expand later if you want more.
  system.defaults = {
    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";
      KeyRepeat = 2;
      InitialKeyRepeat = 15;
      AppleShowAllExtensions = true;
    };
    dock.autohide = true;
    trackpad.Clicking = true;
  };
}
