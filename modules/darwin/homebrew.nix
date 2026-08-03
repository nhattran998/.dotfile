{ user, ... }:
{
  nix-homebrew = {
    enable = true;
    inherit user;
  };

  homebrew = {
    enable = true;

    # SAFE: never uninstall brew packages that are not listed below.
    # (Reference repo uses "zap" — we intentionally do not.)
    onActivation.cleanup = "none";
    onActivation.autoUpdate = true;

    brews = [
      "herdr"
    ];

    casks = [
      "ghostty"
    ];
  };
}
