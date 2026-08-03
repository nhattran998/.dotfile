{
  description = "Harry's multi-host dotfiles (nix-darwin + home-manager + proto)";

  inputs = {
    # Single pin works for darwin host packages and Linux homeConfigurations.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nix-darwin,
      home-manager,
      nix-homebrew,
      ...
    }:
    let
      # macOS login name — bootstrap-mac.sh can rewrite this if it differs.
      user = "harrytran998";

      # Ubuntu server login name (change if different).
      serverUser = "harrytran998";

      # Server CPU: "x86_64-linux" or "aarch64-linux".
      serverSystem = "x86_64-linux";

      mkHome =
        {
          system,
          username,
          modules,
        }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          extraSpecialArgs = {
            inherit user username;
            # home modules that key off the macOS user still see `user`.
          };
          modules = modules;
        };
    in
    {
      # Apple Silicon Mac (M4): nix-darwin + home-manager + nix-homebrew.
      darwinConfigurations.mac = nix-darwin.lib.darwinSystem {
        specialArgs = { inherit user inputs; };
        modules = [
          ./hosts/mac
          nix-homebrew.darwinModules.nix-homebrew
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit user; };
            home-manager.users.${user} = import ./modules/home/mac.nix;
          }
        ];
      };

      # Optional standalone home-manager for Mac (usually unused; darwin path is primary).
      homeConfigurations."${user}@mac" = mkHome {
        system = "aarch64-darwin";
        username = user;
        modules = [ ./modules/home/mac.nix ];
      };

      # Ubuntu server: home-manager only (keep Ubuntu as the OS).
      homeConfigurations."${serverUser}@server" = mkHome {
        system = serverSystem;
        username = serverUser;
        modules = [
          (
            { ... }:
            {
              home.username = serverUser;
              home.homeDirectory = "/home/${serverUser}";
            }
          )
          ./modules/home/linux.nix
        ];
      };
    };
}
