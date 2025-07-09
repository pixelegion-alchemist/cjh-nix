{
  description = "NixOS system with unstable base and Home Manager config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";  # now unstable by default
    stable.url = "github:NixOS/nixpkgs/nixos-25.05";       # optional: stable overlay
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, stable, home-manager, ... }:
    let
      system = "x86_64-linux";

      overlays = [
        (final: prev: {
          # Expose stable as a subpackage
          stable = import stable {
            inherit system;
            config.allowUnfree = true;
          };
        })
      ];

      pkgs = import nixpkgs {
        inherit system overlays;
        config.allowUnfree = true;
      };
    in {
      nixosConfigurations.nixylearn = nixpkgs.lib.nixosSystem {
        inherit system;

        modules = [
          ./machines/nixylearn/configuration.nix
          /etc/nixos/hardware-configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.wowmonkey = import ./home.nix;

            nixpkgs.overlays = overlays;
            nixpkgs.config.allowUnfree = true;
          }
        ];

        inherit pkgs;
      };
    };
}
