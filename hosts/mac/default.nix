{ user, ... }:
{
  imports = [
    ../../modules/darwin/system.nix
    ../../modules/darwin/homebrew.nix
  ];
}
