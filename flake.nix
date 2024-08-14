{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts.url = "github:hercules-ci/flake-parts";
    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, flake-parts, home-manager, nix-darwin, nix-index-database, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "aarch64-darwin" "x86_64-darwin" ];

      perSystem = { pkgs, system, ... }: {
        formatter = pkgs.nixpkgs-fmt;

        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [ nixpkgs-fmt just ];
        };

        packages.default = pkgs.writeShellApplication {
          name = "activate";
          runtimeInputs = [ inputs.home-manager.packages.${system}.default ];
          text = ''
            ${pkgs.lib.getExe inputs.home-manager.packages.${system}.default} switch --flake .#lukasz@${system}
          '';
        };
      };

      flake = {
        homeConfigurations."lukasz@aarch64-darwin" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.aarch64-darwin;
          extraSpecialArgs = { inherit inputs; };
          modules = [
            ./home
            nix-index-database.hmModules.nix-index
            {
              home = {
                username = "lukasz";
                homeDirectory = "/Users/lukasz";
                stateVersion = "24.05";
              };
            }
          ];
        };

        darwinConfigurations."lukasz-macbook-pro-13" = nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = [
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.lukasz = import ./home;
            }
            {
              security.pam.enableSudoTouchIdAuth = true;
              system.stateVersion = 4;
            }
          ];
        };
      };
    };
}
