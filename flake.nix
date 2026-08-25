{
  description = "Harry's developer profile (Home Manager + nix-darwin + Determinate)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/3";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nix-darwin,
      home-manager,
      determinate,
      nix-homebrew,
      ...
    }:
    let
      sudoUser = builtins.getEnv "SUDO_USER";
      envUser = builtins.getEnv "USER";
      usernameFromEnv =
        if sudoUser != "" && sudoUser != "root" then
          sudoUser
        else if envUser != "" && envUser != "root" then
          envUser
        else
          "";
      username = if usernameFromEnv == "" then "harrytran998" else usernameFromEnv;

      eachSystem =
        f:
        nixpkgs.lib.genAttrs [ "aarch64-darwin" "x86_64-darwin" "x86_64-linux" "aarch64-linux" ] (
          system: f (import nixpkgs { inherit system; })
        );

      toolsFor = pkgs: import ./packages/tools.nix { inherit pkgs; };

      homeCommonModules = [
        determinate.homeManagerModules.default
        ./modules/home/common.nix
      ];
      linuxHomeModules = homeCommonModules ++ [ ./modules/home/linux.nix ];
      omarchyHomeModules = linuxHomeModules ++ [ ./modules/home/omarchy.nix ];

      mkHome =
        {
          system,
          modules,
        }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs { inherit system; };
          extraSpecialArgs = {
            inherit username inputs;
          };
          inherit modules;
        };
    in
    {
      devShells = eachSystem (pkgs: {
        default = pkgs.mkShellNoCC {
          packages = (toolsFor pkgs).list;
        };
      });

      packages = eachSystem (
        pkgs:
        let
          t = toolsFor pkgs;
        in
        {
          inherit (t)
            moon
            bun
            pnpm
            node
            glow
            dcg
            caveman
            wigolo
            codegraph
            hunk
            officecli
            herdr
            fx
            scc
            ;
          default = t.moon;
        }
      );

      homeConfigurations.me-linux = mkHome {
        system = "x86_64-linux";
        modules = linuxHomeModules;
      };
      homeConfigurations.me-linux-aarch64 = mkHome {
        system = "aarch64-linux";
        modules = linuxHomeModules;
      };
      homeConfigurations.me-omarchy = mkHome {
        system = "x86_64-linux";
        modules = omarchyHomeModules;
      };
      homeConfigurations.me-omarchy-aarch64 = mkHome {
        system = "aarch64-linux";
        modules = omarchyHomeModules;
      };
      homeConfigurations.me-darwin = mkHome {
        system = "aarch64-darwin";
        modules = homeCommonModules;
      };

      darwinConfigurations.mac = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = {
          inherit username inputs;
        };
        modules = [
          determinate.darwinModules.default
          ./hosts/mac
          nix-homebrew.darwinModules.nix-homebrew
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "before-hm";
            home-manager.extraSpecialArgs = {
              inherit username inputs;
            };
            home-manager.users.${username} = {
              imports = homeCommonModules;
            };
          }
        ];
      };
    };
}
