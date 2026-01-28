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
  };

  outputs = inputs@{ self, nixpkgs, nix-darwin, home-manager, nix-homebrew }:
    let
      username = "mattis";
    in
    {
      # macOS configuration
      darwinConfigurations."macbook" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = { inherit inputs username; };
        modules = [
          ./nix/hosts/macbook
          ./nix/modules/darwin

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
              extraSpecialArgs = { inherit inputs username; };
              users.${username} = import ./nix/modules/home;
            };
          }
        ];
      };

      # NixOS configuration (placeholder for future Linux machines)
      nixosConfigurations."nixos-example" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs username; };
        modules = [
          ./nix/hosts/nixos-example
          ./nix/modules/nixos

          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = { inherit inputs username; };
              users.${username} = import ./nix/modules/home;
            };
          }
        ];
      };
    };
}
