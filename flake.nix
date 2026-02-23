{
  description = "Mattis's system configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = inputs@{ self, nixpkgs, nix-darwin, home-manager, nix-homebrew, disko }:
    let
      username = "mattis";

      # Common nixpkgs configuration for all systems
      nixpkgsConfig = {
        nixpkgs.config.allowUnfree = true;
      };
    in
    {
      # Formatter for `nix fmt`
      formatter.aarch64-darwin = nixpkgs.legacyPackages.aarch64-darwin.nixfmt;
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt;

      # macOS configuration
      darwinConfigurations."macbook" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = { inherit inputs username; hostname = "macbook"; configDir = self; };
        modules = [
          ./nix/hosts/macbook
          ./nix/modules/darwin
          nixpkgsConfig
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              enable = true;
              enableRosetta = true;
              user = username;
              autoMigrate = true;
            };
          }

          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "backup";
              extraSpecialArgs = { inherit inputs username; hostname = "macbook"; configDir = self; };
              users.${username} = import ./nix/modules/home/darwin.nix;
            };
          }
        ];
      };

      # Hetzner VPS with Tailscale SSH
      nixosConfigurations."vps" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs username; configDir = self; };
        modules = [
          ./nix/hosts/vps
          ./nix/modules/nixos
          nixpkgsConfig
          disko.nixosModules.disko

          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = { inherit inputs username; configDir = self; };
              users.${username} = import ./nix/modules/home/linux.nix;
            };
          }
        ];
      };
    };
}
