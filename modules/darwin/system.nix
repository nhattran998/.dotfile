{ username, ... }:
{
  determinateNix.enable = true;
  # Determinate Nix owns the daemon — do not let nix-darwin fight it.
  nix.enable = false;

  nixpkgs.config.allowUnfree = true;
  nixpkgs.hostPlatform = "aarch64-darwin";

  system.primaryUser = username;
  users.users.${username} = {
    home = "/Users/${username}";
  };

  system.stateVersion = 6;

  environment.extraInit = builtins.readFile ../../scripts/source-overlays.sh;

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
