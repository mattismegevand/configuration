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

  outputs =
    inputs@{
      self,
      nixpkgs,
      nix-darwin,
      home-manager,
      nix-homebrew,
      disko,
    }:
    let
      username = "mattis";
      macbookHost = "macbook";
      vpsHost = "vps";
      macbookSystem = "aarch64-darwin";
      vpsSystem = "x86_64-linux";
      macbookFontDir = "/Users/${username}/Library/Mobile Documents/com~apple~CloudDocs/misc/250223LKQVJ0407L/TX-02-4K4X9N9Y";

      # Common nixpkgs configuration for all systems
      nixpkgsConfig = {
        nixpkgs.config.allowUnfree = true;
      };

      formatCheck =
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        pkgs.runCommand "format-check"
          {
            nativeBuildInputs = [ pkgs.nixfmt-tree ];
            src = self;
          }
          ''
            mkdir source
            cp -R "$src/." source/
            chmod -R u+w source
            cd source
            treefmt --ci --tree-root "$PWD" --walk filesystem .
            touch "$out"
          '';
    in
    {
      # Formatter for `nix fmt` (directory-aware wrapper avoids nixfmt deprecation warnings)
      formatter.${macbookSystem} = nixpkgs.legacyPackages.${macbookSystem}.nixfmt-tree;
      formatter.${vpsSystem} = nixpkgs.legacyPackages.${vpsSystem}.nixfmt-tree;

      checks.${macbookSystem}.format = formatCheck macbookSystem;
      checks.${vpsSystem}.format = formatCheck vpsSystem;

      # macOS configuration
      darwinConfigurations.${macbookHost} = nix-darwin.lib.darwinSystem {
        system = macbookSystem;
        specialArgs = {
          inherit inputs username;
          hostname = macbookHost;
          configDir = self;
          berkeleyMonoFontDir = macbookFontDir;
        };
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
              extraSpecialArgs = {
                inherit inputs username;
                hostname = macbookHost;
                configDir = self;
                berkeleyMonoFontDir = macbookFontDir;
              };
              users.${username} = import ./nix/modules/home/darwin.nix;
            };
          }
        ];
      };

      # Hetzner VPS with Tailscale SSH
      nixosConfigurations.${vpsHost} = nixpkgs.lib.nixosSystem {
        system = vpsSystem;
        specialArgs = {
          inherit inputs username;
          configDir = self;
        };
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
              extraSpecialArgs = {
                inherit inputs username;
                configDir = self;
              };
              users.${username} = import ./nix/modules/home/linux.nix;
            };
          }
        ];
      };
    };
}
