{
  description = "NixOS 25.05 base + optional unstable + Home-Manager";

  inputs = {
    nixpkgs.url      = "github:NixOS/nixpkgs/nixos-25.05";
    unstable.url     = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, unstable, home-manager, ... }@inputs:
  let
    system = "x86_64-linux";

    # One overlay that makes pkgs.unstable.* available everywhere
    overlays = [
      (final: prev: {
        unstable = unstable.legacyPackages.${system};
      })
    ];
  in
  {
    nixosConfigurations.nixylearn = nixpkgs.lib.nixosSystem {
      inherit system;

      nixpkgs.overlays = overlays;          #  ← NO specialArgs.pkgs
      modules = [
        ./machines/nixylearn/configuration.nix
        ./machines/nixylearn/hardware-configuration.nix
        home-manager.nixosModules.home-manager

        # little inline module for global knobs
        ({ pkgs, ... }: {
          nixpkgs.config.allowUnfree = true;   # applies to both stable & unstable

          home-manager.useGlobalPkgs   = true;
          home-manager.useUserPackages = true;

          home-manager.users.wowmonkey = import ./home/home.nix;
        })
      ];
    };
  };
}
