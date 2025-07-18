{
  description = "NixOS 25.05 base + optional unstable + Home-Manager";

  inputs = {
    nixpkgs.url      = "github:NixOS/nixpkgs/nixos-25.05";
    unstable.url     = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
  };

  outputs = { self, nixpkgs, unstable, home-manager, nix-flatpak, ... }@inputs:
  let
    system = "x86_64-linux";

    # One overlay that makes pkgs.unstable.* available everywhere
    overlays = [
      (final: prev: {
        unstable = import inputs.unstable {
          inherit (prev.stdenv.hostPlatform) system;

          # copy the same config the main pkgs uses
          config = prev.config;           # brings along allowUnfree = true
        } ;
        nix-flatpak = import inputs.nix-flatpak {
          inherit (prev.stdenv.hostPlatform) system;
          config = prev.config;
        };
        # blender = prev.blender.overrideAttrs (old: let
        #   manifold = prev.manifold;                # already packaged in nixpkgs
        #   clipper2 = prev.clipper2;
        #   tbb = prev.tbb;
        # in rec{
        #   version = "4.5.0";                       # whatever tag you’re bumping to
        #   src     = prev.fetchzip {
        #     url = "https://download.blender.org/source/blender-${version}.tar.xz";
        #     hash = "sha256-ERT/apulQ9ogA7Uk/AfjBee0rLjxEXItw6GwDOoysXk=";
        #   };
        #   buildInputs = old.buildInputs ++ [ manifold clipper2 tbb ];

        #   # Point CMake at the package’s config file
        #   cmakeFlags  = old.cmakeFlags ++ [
        #     "-Dmanifold_DIR=${manifold}/lib/cmake/Manifold"
        #     "-Dclipper2_DIR=${clipper2}/lib/cmake/Clipper2"
        #     "-DTBB_ROOT=${tbb}"
        #     # optional but harmless:
        #     "-DWITH_MANIFOLD=ON"
        #   ];
        # });
      })
    ];
  in
  {
    nixosConfigurations.bloodynix = nixpkgs.lib.nixosSystem {
      inherit system;

      modules = [
        ({ ... }: { nixpkgs.overlays = overlays; })
        ./machines/bloodynix/configuration.nix
        ./machines/bloodynix/hardware-configuration.nix
        home-manager.nixosModules.home-manager
        nix-flatpak.nixosModules.nix-flatpak
        # little inline module for global knobs
        ({ pkgs, ... }: {
          nixpkgs.config.allowUnfree = true;   # applies to both stable & unstable
          nixpkgs.config.cudaSupport = true;
          
          home-manager.useGlobalPkgs   = true;
          home-manager.useUserPackages = true;

          home-manager.users.wowmonkey = import ./home/home.nix;
        })
      ];
      specialArgs = { inherit inputs; };
    };
    
    nixosConfigurations.nixylearn = nixpkgs.lib.nixosSystem {
      inherit system;

      modules = [
        ({ ... }: { nixpkgs.overlays = overlays; })
        ./machines/nixylearn/configuration.nix
        ./machines/nixylearn/hardware-configuration.nix
        home-manager.nixosModules.home-manager
        nix-flatpak.nixosModules.nix-flatpak
        # little inline module for global knobs
        ({ pkgs, ... }: {
          nixpkgs.config.allowUnfree = true;   # applies to both stable & unstable

          home-manager.useGlobalPkgs   = true;
          home-manager.useUserPackages = true;

          home-manager.users.wowmonkey = import ./home/home.nix;
        })
      ];
      specialArgs = { inherit inputs; };
    };

  };
}
