{ username, ... }:
{
  nix-homebrew = {
    enable = true;
    user = username;
  };

  homebrew = {
    enable = true;

    # SAFE: never uninstall brew packages that are not listed below.
    onActivation.cleanup = "none";
    onActivation.autoUpdate = true;

    brews = [ ];

    casks = [
      "ghostty"
    ];
  };
}
